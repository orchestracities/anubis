import os
from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, models, schemas
from ..dependencies import get_db
from sqlalchemy.orm import Session
from ..tenants import operations as so
from ..wac import serialize as w_serialize
from ..rego import serialize as r_serialize
from ..utils import parse_auth_token, OptionalHTTPBearer
import anubis.default as default
import logging
import requests
import urllib


auth_scheme = OptionalHTTPBearer()
router = APIRouter(prefix="/v1/policies",
                   tags=["policies"],
                   responses={404: {"description": "Not found"}},)


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


# def compute_policy_id(policy: models.Policy):
#    return policy.id


@router.get("/access-modes",
            response_model=List[schemas.Mode],
            summary="List supported Access Modes")
def read_modes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    modes = operations.get_modes(db, skip=skip, limit=limit)
    return modes


@router.get("/agent-types",
            response_model=List[schemas.AgentType],
            summary="List supported Agent Types")
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
                    """
                    {
                      "user_permissions": {
                        "admin@mail.com": [
                          {
                            "id": "16c79213-5f9a-42c0-a37f-307c3c1614c3",
                            "action": "acl:Control",
                            "resource": "urn:ngsi-ld:AirQualityObserved:demo",
                            "resource_type": "entity",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          }
                        ]
                      },
                      "default_user_permissions": {},
                      "group_permissions": {
                        "User": [
                          {
                            "id": "1180e176-a39b-4dd0-b261-1c030123395d",
                            "action": "acl:Read",
                            "resource": "/v2/entities/some_entity",
                            "resource_type": "entity",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          }
                        ]
                      },
                      "default_group_permissions": {},
                      "role_permissions": {
                        "AuthenticatedAgent": [
                          {
                            "id": "eecd7954-03e9-4a58-9076-79c4c9fa26d5",
                            "action": "acl:Write",
                            "resource": "*",
                            "resource_type": "entity",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "91934c76-5017-44c4-9cc8-8fac8ebffa59",
                            "action": "acl:Control",
                            "resource": "*",
                            "resource_type": "entity",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "6d0d3663-125a-494e-9f18-aa0d2e8725a3",
                            "action": "acl:Read",
                            "resource": "*",
                            "resource_type": "policy",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "cdd1530d-669d-41d2-b79e-62eb4f70428e",
                            "action": "acl:Write",
                            "resource": "*",
                            "resource_type": "policy",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "0860514b-da0f-4e89-813b-4675aef1e2fe",
                            "action": "acl:Read",
                            "resource": "Tenant1",
                            "resource_type": "tenant",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "15f707e6-efd5-481a-b624-ea90046876da",
                            "action": "acl:Write",
                            "resource": "Tenant1",
                            "resource_type": "tenant",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "0641364c-9215-4f2e-aa0b-577d6bb9a4a3",
                            "action": "acl:Read",
                            "resource": "/",
                            "resource_type": "service_path",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "685f98a3-71cb-4867-86e5-939bb838786b",
                            "action": "acl:Write",
                            "resource": "/",
                            "resource_type": "service_path",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          }
                        ]
                      },
                      "default_role_permissions": {
                        "AuthenticatedAgent": [
                          {
                            "id": "f0c9d421-5da5-439b-85b9-84d6636af9d8",
                            "action": "acl:Read",
                            "resource": "default",
                            "resource_type": "entity",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          }
                        ],
                        "Admin": [
                          {
                            "id": "5700d831-4f59-4f2c-9aab-01ab010193cd",
                            "action": "acl:Control",
                            "resource": "default",
                            "resource_type": "policy",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          },
                          {
                            "id": "6caff4de-ce49-4cd3-a3d8-1a808bd4cbbd",
                            "action": "acl:Control",
                            "resource": "default",
                            "resource_type": "entity",
                            "service_path": "/",
                            "tenant": "Tenant1"
                          }
                        ]
                      }
                    }"""
                }
            }
        }
    },
}

# TODO if no token, we should return policies for foaf:Agent!


@router.get("/me",
            response_model=List[schemas.Policy],
            responses=policies_not_json_responses,
            summary="List policies for a given Tenant and Service Path that apply to me")
def my_policies(
        token: str = Depends(auth_scheme),
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
    """
    Policies can be filtered by:
      - Access Mode
      - Agent
      - Agent Type
      - Resource
      - Resource Type
    Requires a JWT token: contained user id, roles and groups are used to
    filter policies that are only valid for the user.
    To return policies from a service path tree, you can used the wildchar "#".
    For example, using `/Path1/#` you will obtain policies for all subpaths,
    such as: `/Path1/SubPath1` or `/Path1/SubPath1/SubSubPath1`.
    """
    user_info = parse_auth_token(token)
    if not user_info:
        raise HTTPException(
            status_code=403,
            detail='missing access token, cannot identify user'
        )
    if agent_type and agent_type not in default.DEFAULT_AGENTS and agent_type not in default.DEFAULT_AGENT_TYPES:
        raise HTTPException(
            status_code=422,
            detail='agent_type {} is not a valid agent type. Valid types are {} or {}'.format(
                agent_type,
                default.DEFAULT_AGENTS,
                default.DEFAULT_AGENT_TYPES))
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(so.compute_id, db_service_path))
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


@router.get("/",
            response_model=List[schemas.Policy],
            responses=policies_not_json_responses,
            summary="List policies for a given Tenant and Service Path")
def read_policies(
        token: str = Depends(auth_scheme),
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
    """
    Policies can be filtered by:
      - Access Mode
      - Agent
      - Agent Type
      - Resource
      - Resource Type
    In case an JWT token is passed over, user id is used to filter policies
    where the owner is user id. Unless the user is super admin or tenant admin.
    To return policies from a service path tree, you can used the wildchar "#".
    For example, using `/Path1/#` you will obtain policies for all subpaths,
    such as: `/Path1/SubPath1` or `/Path1/SubPath1/SubSubPath1`.
    """
    user_info = parse_auth_token(token)
    owner = None
    if user_info and user_info['is_super_admin']:
        owner = None
    elif user_info and user_info['tenants'] and fiware_service in user_info['tenants'] and "roles" in user_info['tenants'][fiware_service] and "tenant-admin" in user_info['tenants'][fiware_service]["roles"]:
        owner = None
    elif user_info and user_info['email']:
        owner = user_info['email']
    # we don't filter policies in case super admin or tenant admin
    if agent_type and agent_type not in default.DEFAULT_AGENTS and agent_type not in default.DEFAULT_AGENT_TYPES:
        raise HTTPException(
            status_code=422,
            detail='agent_type {} is not a valid agent type. Valid types are {} or {}'.format(
                agent_type,
                default.DEFAULT_AGENTS,
                default.DEFAULT_AGENT_TYPES))
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(so.compute_id, db_service_path))
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
        owner=owner)
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
            responses=policies_not_json_responses, summary="Get a policy")
def read_policy(
        policy_id: str,
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/#'),
        accept: Optional[str] = Header(
            None),
        db: Session = Depends(get_db)):
    db_service_path = so.get_db_service_path(
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

# TODO: 0. if at least provider exists (beyond the node itself), we should not
# create default policies in lua
# TODO: 1. before creating a policy for a resource, subscribe to it.
# should be done in lua on resource creation? yes, but in this case,
# we need to be able to ensure that the synched policies are created
# for the tenant where the new resource is created (i.e. we need to pass
# the correct headers in the subscription process), otherwise
# - in case of IS_PRIVATE_ORG=FALSE - we won't know the tenant for the resource
# and we will create policy in tenant 'Default' which would
# be wrong ).


@router.post("/",
             response_class=Response,
             status_code=status.HTTP_201_CREATED,
             summary="Create a policy for a given Tenant and Service Path")
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
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(so.compute_id, db_service_path))
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
    try:
        middleware_url = os.environ.get('MIDDLEWARE_ENDPOINT', None)
        # we don't synch policies that are not specific to a resource
        if middleware_url and policy.access_to != 'default' and policy.access_to != '*':
            headers = {
                "fiware-Service": fiware_service,
                "fiware-Servicepath": fiware_servicepath}
            # if policy created, register yourself as a provider
            res = requests.post(
                middleware_url +
                "/resource/" +
                urllib.parse.quote(policy.access_to) +
                "/provide",
                headers=headers)
            if res.status_code != 200:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
            # if policy created, send new notification
            res = requests.post(
                middleware_url +
                "/resource/" +
                urllib.parse.quote(policy.access_to) +
                "/policy/" +
                policy_id,
                headers=headers)
            if res.status_code != 200:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
    except HTTPException as e:
        logging.warning(
            "failed middleware synchronization for {}".format(
                urllib.parse.quote(
                    policy.access_to)))
        logging.error(e)
    return response


@router.put("/{policy_id}",
            response_class=Response,
            status_code=status.HTTP_204_NO_CONTENT,
            summary="Update a policy for a given Tenant and Service Path")
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
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_service_path_id = list(map(so.compute_id, db_service_path))
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
    try:
        middleware_url = os.environ.get('MIDDLEWARE_ENDPOINT', None)
        # we don't synch policies that are not specific to a resource
        if middleware_url and policy.access_to != 'default' and policy.access_to != '*':
            headers = {
                "fiware-Service": fiware_service,
                "fiware-Servicepath": fiware_servicepath}
            # if policy updated, send update notification
            res = requests.put(
                middleware_url +
                "/resource/" +
                urllib.parse.quote(policy.access_to) +
                "/policy/" +
                policy_id,
                headers=headers)
            if res.status_code != 200:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
    except HTTPException as e:
        logging.warning(
            "failed middleware synchronization for {}".format(
                urllib.parse.quote(
                    policy.access_to)))
        logging.error(e)
    return response


@router.delete("/{policy_id}",
               response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT,
               summary="Delete a policy for a given Tenant and Service Path")
def delete_policy(
        response: Response,
        policy_id: str,
        fiware_service: Optional[str] = Header(
            None),
    fiware_servicepath: Optional[str] = Header(
            None),
        db: Session = Depends(get_db)):
    db_service_path = so.get_db_service_path(
        db, fiware_service, fiware_servicepath)
    db_policy = operations.get_policy(db, policy_id=policy_id)
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    if db_service_path[0].id != db_policy.service_path_id:
        raise HTTPException(status_code=404, detail="Policy not found")
    operations.delete_policy(db=db, policy=db_policy)
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_204_NO_CONTENT
    try:
        middleware_url = os.environ.get('MIDDLEWARE_ENDPOINT', None)
        # we don't synch policies that are not specific to a resource
        if middleware_url and db_policy.access_to != 'default' and db_policy.access_to != '*':
            headers = {
                "fiware-Service": fiware_service,
                "fiware-Servicepath": fiware_servicepath}
            # if policy deleted, send delete notification
            res = requests.delete(
                middleware_url +
                "/resource/" +
                urllib.parse.quote(db_policy.access_to) +
                "/policy/" +
                policy_id,
                headers=headers)
            if res.status_code != 200:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
    except HTTPException as e:
        logging.warning(
            "failed middleware synchronization for {}".format(
                urllib.parse.quote(
                    db_policy.access_to)))
        logging.error(e)
    return response
