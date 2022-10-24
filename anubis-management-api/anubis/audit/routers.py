import gzip
from typing import Callable, List, Optional
from fastapi import Depends, Body, Request, APIRouter, HTTPException, status, Response, Header
from fastapi.routing import APIRoute
from . import operations, models, schemas
from ..tenants import operations as so
import anubis.default as default
from ..dependencies import get_db
from sqlalchemy.orm import Session
from datetime import datetime
from sqlalchemy.exc import IntegrityError, PendingRollbackError
from anonymizeip import anonymize_ip
import re
from ..utils import parse_auth_token, extract_auth_token, OptionalHTTPBearer

auth_scheme = OptionalHTTPBearer()


class GzipRequest(Request):
    async def body(self) -> bytes:
        if not hasattr(self, "_body"):
            body = await super().body()
            if "gzip" in self.headers.getlist("Content-Encoding"):
                body = gzip.decompress(body)
            self._body = body
        return self._body


class GzipRoute(APIRoute):
    def get_route_handler(self) -> Callable:
        original_route_handler = super().get_route_handler()

        async def custom_route_handler(request: Request) -> Response:
            request = GzipRequest(request.scope, request.receive)
            return await original_route_handler(request)

        return custom_route_handler


router = APIRouter(
    prefix="/v1/audit",
    tags=["audit"],
    responses={
        404: {
            "description": "Not found"}},
    route_class=GzipRoute)


@router.get("/logs",
            response_model=List[schemas.AuditLog],
            summary="List all Audit Logs")
def read_audit_logs(
        token: str = Depends(auth_scheme),
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/#'),
        user: Optional[str] = None,
        resource: Optional[str] = None,
        resource_type: Optional[str] = None,
        mode: Optional[str] = None,
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
    user_info = parse_auth_token(token)
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(so.compute_id, db_service_path))
    db_logs = operations.get_logs_by_service_path(
        db,
        service_path_id=db_service_path_id,
        user=user,
        resource=resource,
        resource_type=resource_type,
        mode=mode,
        decision=decision,
        type=type,
        service=service,
        fromDate=fromDate,
        toDate=toDate,
        skip=skip,
        limit=limit,
        user_info=user_info)
    return db_logs


@router.get("/logs/{audit_id}",
            response_model=schemas.AuditLog,
            summary="Get an Audit Log")
def read_audit_log(audit_id: str,
                   token: str = Depends(auth_scheme),
                   fiware_service: Optional[str] = Header(
                       None),
                   fiware_servicepath: Optional[str] = Header(
                       '/#'),
                   db: Session = Depends(get_db)):
    """
    TODO:
    Logs can be filtered by:
    In case an JWT token is passed over ...
    """
    db_tenant = so.get_tenant_by_name(db, name=fiware_service)
    if not db_tenant:
        raise HTTPException(
            status_code=404,
            detail="Tenant {} not found".format(fiware_service))
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    if not db_service_path:
        raise HTTPException(
            status_code=404,
            detail="Service Path {} not found".format(fiware_servicepath))
    db_service_path_id = list(map(so.compute_id, db_service_path))
    db_log = operations.get_log_by_id_and_service_path(
        db,
        audit_id,
        db_service_path_id,
        None)
    if not db_log:
        raise HTTPException(
            status_code=404,
            detail="Audit Log {} not found".format(audit_id))
    return db_log


#  Opa expects HTTP_200_OK HTTP_201_CREATED and other status will not be
#  considered valid and will cause infinite retries.
#  TODO see issue https://github.com/open-policy-agent/opa/issues/4820
@router.post("/logs",
             response_class=Response,
             status_code=status.HTTP_200_OK,
             summary="Create Audit Logs")
def create_audit_log(
        response: Response,
        opa_logs: List[schemas.OpaDecisionLog],
        db: Session = Depends(get_db)):
    errors = []
    for opa_log in opa_logs:
        try:
            remote_ip = None
            if opa_log.input['attributes']['source']['address']['socketAddress']['address']:
                remote_ip = anonymize_ip(
                    opa_log.input['attributes']['source']['address']['socketAddress']['address'])
            decision = None
            if opa_log.result['allowed']:
                decision = opa_log.result['allowed']
            if not decision:
                raise HTTPException(
                    status_code=422,
                    detail="Decision cannot be none")
            mode = None
            if opa_log.input['mode']:
                mode = opa_log.input['mode']
            if not mode:
                raise HTTPException(
                    status_code=422, detail="Mode cannot be none")
            resource = None
            if opa_log.input['resource']:
                resource = opa_log.input['resource']
            if not resource:
                raise HTTPException(
                    status_code=422,
                    detail="Resource cannot be none")
            resource_type = None
            if opa_log.input['resource_type']:
                resource_type = opa_log.input['resource_type']
            if not resource_type:
                raise HTTPException(
                    status_code=422,
                    detail="Resource Type cannot be none")
            service = None
            if opa_log.input['service']:
                service = opa_log.input['service']
            if not service:
                raise HTTPException(
                    status_code=422,
                    detail="Service cannot be none")
            user = None
            if opa_log.input['attributes']['request']['http']['headers']['authorization']:
                authorization = opa_log.input['attributes']['request']['http']['headers']['authorization']
                opa_log_token = parse_auth_token(
                    extract_auth_token(authorization))
                if opa_log_token:
                    user = re.sub(r'[^@.]', 'x', opa_log_token['email'])
            tenant = None
            if opa_log.input['attributes']['request']['http']['headers']['fiware-service']:
                tenant = opa_log.input['attributes']['request']['http']['headers']['fiware-service']
                tenant_db = so.get_tenant_by_name(db, tenant)
                if not tenant_db:
                    raise HTTPException(
                        status_code=404,
                        detail="Tenant " +
                        tenant +
                        " not found")
            if not tenant:
                raise HTTPException(
                    status_code=422, detail="Tenant cannot be none")
            service_path_id = None
            if opa_log.input['attributes']['request']['http']['headers']['fiware-servicepath']:
                service_path = opa_log.input['attributes']['request']['http']['headers']['fiware-servicepath']
                service_path_db = so.get_db_service_path(
                    db, tenant, service_path)
                if not service_path_db:
                    raise HTTPException(
                        status_code=404,
                        detail="Service Path {} not found".format(service_path))
                service_path_id = service_path_db[0].id
            audit_log = schemas.AuditLogCreate(id=opa_log.decision_id,
                                               type="access",
                                               service=service,
                                               resource=resource,
                                               resource_type=resource_type,
                                               mode=mode,
                                               decision=decision,
                                               user=user,
                                               remote_ip=remote_ip,
                                               timestamp=opa_log.timestamp
                                               )
            operations.create_audit_log(db, audit_log, service_path_id)
        except IntegrityError:
            db.rollback()
            operations.update_audit_log(db, opa_log.decision_id, audit_log)
        except HTTPException as e:
            error = {
                'id': opa_log.decision_id,
                'errorType': type(e).__name__,
                'errorMessage': e.detail}
            errors.append(error)
        except Exception as e:
            error = {
                'id': opa_log.decision_id,
                'errorType': type(e).__name__}
            errors.append(error)
    if errors and len(errors) > 0:
        raise HTTPException(status_code=200, detail=errors)
    else:
        response.status_code = status.HTTP_200_OK
    return response


@router.delete("/logs/{audit_id}",
               response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT,
               summary="Delete an Audit Log for a given Tenant and Service Path")
def delete_log(
        response: Response,
        audit_id: str,
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            "/#"),
        db: Session = Depends(get_db)):
    db_tenant = so.get_tenant_by_name(db, name=fiware_service)
    if not db_tenant:
        raise HTTPException(
            status_code=404,
            detail="Tenant {} not found".format(fiware_service))
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    if not db_service_path:
        raise HTTPException(
            status_code=404,
            detail="Service Path {} not found".format(fiware_servicepath))
    db_service_path_id = list(map(so.compute_id, db_service_path))
    db_log = operations.get_log_by_id_and_service_path(
        db,
        audit_id,
        db_service_path_id,
        None)
    if not db_log:
        raise HTTPException(
            status_code=404,
            detail="Audit Log {} not found".format(audit_id))
    operations.delete_log(db=db, log=db_log)
    response.headers["Audit-ID"] = audit_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response
