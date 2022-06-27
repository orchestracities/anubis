from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, models, schemas
from ..tenants import operations as so
from ..utils import parse_auth_token
import anubis.default as default
from ..dependencies import get_db
from sqlalchemy.orm import Session
from datetime import datetime
from sqlalchemy.exc import IntegrityError
import json

router = APIRouter(prefix="/v1/audit",
                   tags=["audit"],
                   responses={404: {"description": "Not found"}},)


@router.get("/logs",
            response_model=List[schemas.AccessLog],
            summary="List all Access Logs")
def read_access_logs(
        authorization: Optional[str] = Header(
            None),
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/#'),
        user: Optional[str] = None,
        resource: Optional[str] = None,
        method: Optional[str] = None,
        decision: Optional[str] = None,
        type: Optional[str] = None,
        service: Optional[str] = None,
        fromDate: Optional[datetime] = None,
        toDate: Optional[datetime] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    """
    TODO:
    Logs can be filtered by:
    In case an JWT token is passed over ...
    """
    user_info = None
    if authorization:
        user_info = parse_auth_token(authorization)
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(so.compute_id, db_service_path))
    db_logs = operations.get_logs_by_service_path(
        db,
        service_path_id=db_service_path_id,
        user=user,
        resource=resource,
        method=method,
        decision=decision,
        type=type,
        service=service,
        fromDate=fromDate,
        toDate=toDate,
        skip=skip,
        limit=limit,
        user_info=user_info)
    return db_logs

@router.post("/logs",
            response_class=Response,
            status_code=status.HTTP_201_CREATED,
            summary="Create Access Logs")
def create_access_log(
        response: Response,
        opa_logs: List[schemas.OpaDecisionLogBase],
        db: Session = Depends(get_db)):
    errors = []
    for opa_log in opa_logs:
        try:
            remote_ip = None
            if opa_log.input['attributes']['source']['address']['socketAddress']['address']:
                remote_ip = opa_log.input['attributes']['source']['address']['socketAddress']['address']
            decision = None
            if opa_log.result['allowed']:
                decision = opa_log.result['allowed']
            if not decision:
                raise HTTPException(status_code=422, detail="Decision cannot be none")
            # at the time being we simplify logging the method and not the mode
            method = None
            if opa_log.input['attributes']['request']['http']['method']:
                method = opa_log.input['attributes']['request']['http']['method']
            if not method:
                raise HTTPException(status_code=422, detail="Method cannot be none")
            # at the time being we simplify logging as resource the request path
            resource = None
            if opa_log.input['attributes']['request']['http']['path']:
                resource = opa_log.input['attributes']['request']['http']['path']
            if not resource:
                raise HTTPException(status_code=422, detail="Resource cannot be none")
            # at the time being we simplify logging as service the host
            service = None
            if opa_log.input['attributes']['request']['http']['host']:
                service = opa_log.input['attributes']['request']['http']['host']
            if not service:
                raise HTTPException(status_code=422, detail="Service cannot be none")
            user = None
            if opa_log.input['attributes']['request']['http']['headers']['authorization']:
                authorization = opa_log.input['attributes']['request']['http']['headers']['authorization']
                token = parse_auth_token(authorization)
                if token:
                    user = token['email']
            tenant_id = None
            tenant = None
            if opa_log.input['attributes']['request']['http']['headers']['fiware-service']:
                tenant = opa_log.input['attributes']['request']['http']['headers']['fiware-service']
                tenant_db = so.get_tenant_by_name(db, tenant)
                if not tenant_db:
                    raise HTTPException(status_code=404, detail="Tenant " + tenant + " not found")
                tenant_id = tenant_db.id
            if not tenant:
                raise HTTPException(status_code=422, detail="Tenant cannot be none")
            service_path_id = None
            if opa_log.input['attributes']['request']['http']['headers']['fiware-servicepath']:
                service_path = opa_log.input['attributes']['request']['http']['headers']['fiware-servicepath']
                service_path_db = so.get_db_service_path(db, tenant, service_path)
                if not service_path_db:
                    raise HTTPException(status_code=404, detail="Service Path " + service_path + " not found")
                service_path_id = service_path_db[0].id
            access_log = schemas.AccessLogCreate(id = opa_log.decision_id,
                type = "access",
                service = service,
                resource = resource,
                method = method,
                decision = decision,
                user = user,
                remote_ip = remote_ip,
                timestamp = opa_log.timestamp
            )
            operations.create_access_log(db, access_log, service_path_id)
        except Exception as e:
            error = { 'id': opa_log.decision_id, 'errorType': type(e).__name__}
            if isinstance(e,IntegrityError):
                error['errorMessage'] = e._message()
            if isinstance(e,HTTPException):
                error['errorMessage'] = e.detail
            errors.append(error)
    if errors and len(errors) > 0:
        raise HTTPException(status_code=422, detail=errors)
    else:
        response.status_code = status.HTTP_201_CREATED
    return response