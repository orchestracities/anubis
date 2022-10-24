from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, schemas
from ..dependencies import get_db
from sqlalchemy.orm import Session
from ..utils import parse_auth_token, OptionalHTTPBearer
import anubis.default as default

auth_scheme = OptionalHTTPBearer()
router = APIRouter(prefix="/v1/resources",
                   tags=["resources"],
                   responses={404: {"description": "Not found"}}, )


def serialize_resource(resource):
    return schemas.Resource(
        id=resource.access_to,
        type=resource.resource_type,
        tenant=resource.name,
        servicePath=resource.path)


@router.get("/",
            response_model=List[schemas.Resource],
            summary="List resources managed (for a given Tenant and Service Path)")
def resources(
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            None),
        resource_type: Optional[str] = None,
        owner: Optional[str] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    db_resources = operations.get_resources(
        db,
        tenant=fiware_service,
        service_path=fiware_servicepath,
        resource_type=resource_type,
        skip=skip,
        limit=limit,
        owner=owner)
    res = []
    for db_resource in db_resources:
        res.append(serialize_resource(db_resource))
    return res


@router.get("/mine",
            response_model=List[schemas.Resource],
            summary="List resources owned by me")
def my_resources(
        token: str = Depends(auth_scheme),
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            None),
        resource_type: Optional[str] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    if not token:
        raise HTTPException(
            status_code=400,
            detail="Missing token: cannot identify user")
    user_info = parse_auth_token(token)
    if not user_info['email']:
        raise HTTPException(
            status_code=400,
            detail="Token does not include email")
    user_agent = default.AGENT_IRI + ":" + user_info['email']
    db_resources = operations.get_resources(
        db,
        tenant=fiware_service,
        service_path=fiware_servicepath,
        resource_type=resource_type,
        skip=skip,
        limit=limit,
        owner=user_agent)
    res = []
    for db_resource in db_resources:
        res.append(serialize_resource(db_resource))
    return res
