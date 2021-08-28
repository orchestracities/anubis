from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, models, schemas
from dependencies import get_db
from database import engine
from sqlalchemy.orm import Session
from tenants import operations as so
from wac import serialize as w_serialize
from rego import serialize as r_serialize


models.Base.metadata.create_all(bind=engine)

router = APIRouter(prefix="/v1/policies",
                   tags=["policies"],
                   responses={404: {"description": "Not found"}},)


def get_db_service_path(db: Session, tenant: str, service_path: str):
    db_tenant = so.get_tenant_by_name(db, name=tenant)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    db_service_path = so.get_tenant_service_path_by_path(
        db, tenant_id=db_tenant.id, path=service_path)
    if not db_service_path:
        raise HTTPException(status_code=404, detail="Service Path not found")
    return db_service_path


def serialize_policy(policy: models.Policy):
    modes = []
    agents = []
    for index, mode in enumerate(policy.mode):
        modes.append(mode.iri)
    for index, agent in enumerate(policy.agent):
        agents.append(agent.iri)
    return schemas.Policy(
        id=policy.id,
        access_to=policy.access_to,
        mode=modes,
        agent=agents)


@router.get("/access-modes", response_model=List[schemas.Mode])
def read_modes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    modes = operations.get_modes(db, skip=skip, limit=limit)
    return modes


@router.get("/agent-types", response_model=List[schemas.AgentType])
def read_modes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    types = operations.get_agent_types(db, skip=skip, limit=limit)
    return types


policies_not_json_responses = {
    200: {
        "description": "Success",
        "content": {
            "text/turtle": {
                "schema": {
                    "type": "string"
                },
                "example": {
                    """@prefix acl: <http://www.w3.org/ns/auth/acl#> .

<http:/www.w3.org/ns/auth/0723f0fd-785d-4091-bcc7-964361602421> acl:accessTo </v2/entities/urn:pippo> ;
    acl:agentClass <acl:AuthenticatedAgent> ;
    acl:mode <acl:Read>,
        <acl:Write> .

<http:/www.w3.org/ns/auth/16bdc820-4177-4403-a3e5-7c12abb57751> acl:accessTo </v2/entities/> ;
    acl:agentClass <acl:AuthenticatedAgent> ;
    acl:mode <acl:Read> .""",
                }
            },
            "text/rego": {
                "schema": {
                    "type": "string"
                },
                "example": {
                    """package enyoy.authz.4385a69f-6d3d-49ed-b342-848f30297a05
                    'tenant = "EKZ"
                    {...}
                    resource_allowed {
                        fiware_service = tenant
                        is_token_valid
                        glob.match("/v2/entities/", ["/"], path)
                        contains_element(scope_method["acl:Read"], method)
                        glob.match("/", ["/"], fiware_servicepath)
                    }"""
                }
            }
        }
    },
}


@router.get("/",
            response_model=List[schemas.Policy],
            responses=policies_not_json_responses)
def read_policies(
        fiware_service: Optional[str] = Header(
            None,
            convert_underscores=False),
    fiware_service_path: Optional[str] = Header(
            None,
            convert_underscores=False),
        mode: Optional[str] = None,
        agent: Optional[str] = None,
        accept: Optional[str] = Header(
            None,
            convert_underscores=False),
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_service_path)
    db_policies = operations.get_policies_by_service_path(
        db,
        service_path_id=db_service_path.id,
        mode=mode,
        agent=agent,
        skip=skip,
        limit=limit)
    if accept == 'text/turtle':
        return Response(
            content=w_serialize(
                db,
                db_policies),
            media_type="text/turtle")
    elif accept == 'text/rego':
        return Response(
            content=r_serialize(
                db,
                db_policies),
            media_type="text/rego")
    else:
        policies = []
        for db_policy in db_policies:
            policies.append(serialize_policy(db_policy))
        return policies


@router.get("/{policy_id}", response_model=schemas.Policy,
            responses=policies_not_json_responses)
def read_policy(
        policy_id: str,
        fiware_service: Optional[str] = Header(
            None,
            convert_underscores=False),
    fiware_service_path: Optional[str] = Header(
            None,
            convert_underscores=False),
        accept: Optional[str] = Header(
            None,
            convert_underscores=False),
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_service_path)
    db_policy = operations.get_policy(db, policy_id=policy_id)
    if db_service_path.id != db_policy.service_path_id:
        raise HTTPException(status_code=404, detail="Policy not found")
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    if accept == 'text/turtle':
        return Response(
            content=w_serialize(
                db,
                [db_policy]),
            media_type="text/turtle")
    elif accept == 'text/rego':
        return Response(
            content=r_serialize(
                db,
                [db_policy]),
            media_type="text/rego")
    else:
        return serialize_policy(db_policy)


@router.post("/", response_class=Response, status_code=status.HTTP_201_CREATED)
def create_policy(
        response: Response,
        policy: schemas.PolicyCreate,
        fiware_service: Optional[str] = Header(
            None,
            convert_underscores=False),
    fiware_service_path: Optional[str] = Header(
            None,
            convert_underscores=False),
        db: Session = Depends(get_db)):
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_service_path)

    policy_id = operations.create_policy(
        db=db, service_path_id=db_service_path.id, policy=policy).id
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_201_CREATED
    return response

# TODO update policy
# @router.put("/{policy_id}")


@router.delete("/{policy_id}", response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT)
def delete_policy(
        response: Response,
        policy_id: str,
        fiware_service: Optional[str] = Header(
            None,
            convert_underscores=False),
    fiware_service_path: Optional[str] = Header(
            None,
            convert_underscores=False),
        db: Session = Depends(get_db)):
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_service_path)
    db_policy = operations.get_policy(db, policy_id=policy_id)
    if db_service_path.id != db_policy.service_path_id:
        raise HTTPException(status_code=404, detail="Policy not found")
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    operations.delete_policy(db=db, policy=db_policy)
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response
