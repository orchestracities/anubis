from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, models, schemas
from ..dependencies import get_db
from sqlalchemy.orm import Session
from ..tenants import operations as so
from ..wac import serialize as w_serialize
from ..rego import serialize as r_serialize
import anubis.default as default
import jwt


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
        resource_type=policy.resource_type,
        mode=modes,
        agent=agents)


def parse_auth_token(auth_string: str):
    token = auth_string.split(" ")
    if token[0] == "Bearer":
        token = token[1]
        token = jwt.decode(token, options={"verify_signature": False})
        user_info = {}
        user_info["email"] = token["email"]
        user_info["tenants"] = token["tenants"]
        return user_info
    return None


def compute_policy_id(policy: models.Policy):
    return policy.id


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
        authorization: Optional[str] = Header(
            None),
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/#'),
        mode: Optional[str] = None,
        agent: Optional[str] = None,
        accept: Optional[str] = Header(
            'application/json'),
        resource: Optional[str] = None,
        resource_type: Optional[str] = None,
        agent_type: Optional[str] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    user_info = None
    if authorization:
        user_info = parse_auth_token(authorization)
    if agent_type and agent_type not in default.DEFAULT_AGENTS and agent_type not in default.DEFAULT_AGENT_TYPES:
        raise HTTPException(
            status_code=422,
            detail='agent_type {} is not a valid agent type. Valid types are {} or {}'.format(
                agent_type,
                default.DEFAULT_AGENTS,
                default.DEFAULT_AGENT_TYPES))
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(compute_policy_id, db_service_path))
    db_policies = operations.get_policies_by_service_path(
        db,
        tenant=fiware_service,
        service_path_id=db_service_path_id,
        mode=mode,
        agent=agent,
        agent_type=agent_type,
        resource=resource,
        resource_type=resource_type,
        skip=skip,
        limit=limit,
        user_info=user_info)
    if accept == 'text/turtle':
        return Response(
            content=w_serialize(
                db,
                fiware_service,
                fiware_servicepath,
                db_policies),
            media_type="text/turtle")
    elif accept == 'text/rego':
        return Response(
            content=r_serialize(
                db,
                db_policies),
            media_type="application/json")
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
            None),
    fiware_servicepath: Optional[str] = Header(
            '/#'),
        accept: Optional[str] = Header(
            None),
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_policy = operations.get_policy(db, policy_id=policy_id)
    if not db_policy or db_service_path[0].id != db_policy.service_path_id:
        raise HTTPException(status_code=404, detail="Policy not found")
    if accept == 'text/turtle':
        return Response(
            content=w_serialize(
                db,
                fiware_service,
                fiware_servicepath,
                [db_policy]),
            media_type="text/turtle")
    elif accept == 'text/rego':
        return Response(
            content=r_serialize(
                db,
                [db_policy]),
            media_type="application/json")
    else:
        return serialize_policy(db_policy)


@router.post("/", response_class=Response, status_code=status.HTTP_201_CREATED)
def create_policy(
        response: Response,
        policy: schemas.PolicyCreate,
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/'),
        db: Session = Depends(get_db)):
    if policy.resource_type == "tenant" and policy.access_to != fiware_service:
        raise HTTPException(
            status_code=422,
            detail="access_to field needs to be the same as fiware_service when using type tenant")
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(compute_policy_id, db_service_path))
    policies = []
    for agent in policy.agent:
        for mode in policy.mode:
            db_policies = operations.get_policies_by_service_path(
                db=db,
                tenant=fiware_service,
                service_path_id=db_service_path_id,
                mode=mode,
                agent=agent,
                resource=policy.access_to,
                resource_type=policy.resource_type,
            )
            policies = policies + db_policies
    if len(db_policies) > 0:
        raise HTTPException(
            status_code=422,
            detail="a policy with those modes/agents already exists for that resource")
    policy_id = operations.create_policy(
        db=db, service_path_id=db_service_path_id[0], policy=policy).id
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_201_CREATED
    return response


@router.put("/{policy_id}", response_class=Response,
            status_code=status.HTTP_204_NO_CONTENT)
def update(
        response: Response,
        policy_id: str,
        policy: schemas.PolicyCreate,
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/'),
        db: Session = Depends(get_db)):
    if policy.resource_type == "tenant" and policy.access_to != fiware_service:
        raise HTTPException(
            status_code=422,
            detail="access_to field needs to be the same as fiware_service when using type tenant")
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(compute_policy_id, db_service_path))
    db_policy = operations.get_policy(db, policy_id=policy_id)
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    if db_service_path_id[0] != db_policy.service_path_id:
        raise HTTPException(status_code=404, detail="Policy not found")
    policies = []
    for agent in policy.agent:
        for mode in policy.mode:
            db_policies = operations.get_policies_by_service_path(
                db=db,
                tenant=fiware_service,
                service_path_id=db_service_path_id,
                mode=mode,
                agent=agent,
                resource=policy.access_to,
                resource_type=policy.resource_type,
            )
            policies = policies + db_policies
    if len(db_policies) > 0 and db_policies[0].id != policy_id:
        raise HTTPException(
            status_code=422,
            detail="a policy with those modes/agents already exists for that resource")
    response.headers["Policy-ID"] = operations.update_policy(
        db=db, policy_id=policy_id, policy=policy)
    response.status_code = status.HTTP_204_NO_CONTENT
    return response


@router.delete("/{policy_id}", response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT)
def delete_policy(
        response: Response,
        policy_id: str,
        fiware_service: Optional[str] = Header(
            None),
    fiware_servicepath: Optional[str] = Header(
            None),
        db: Session = Depends(get_db)):
    db_service_path = get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_policy = operations.get_policy(db, policy_id=policy_id)
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    if db_service_path[0].id != db_policy.service_path_id:
        raise HTTPException(status_code=404, detail="Policy not found")
    operations.delete_policy(db=db, policy=db_policy)
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response
