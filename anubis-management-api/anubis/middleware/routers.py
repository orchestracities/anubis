from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, schemas
from ..dependencies import get_db
from sqlalchemy.orm import Session
from ..utils import parse_auth_token, OptionalHTTPBearer
import anubis.default as default
from ..policies import routers as rp
from ..policies import schemas as sp
from ..policies import operations as op
from ..tenants import operations as ot
from ..tenants import schemas as st
import logging

auth_scheme = OptionalHTTPBearer()
router = APIRouter(prefix="/v1/middleware",
                   tags=["middleware"],
                   responses={404: {"description": "Not found"}}, )


def serialize_resource(resource):
    return schemas.Resource(
        id=resource.access_to,
        type=resource.resource_type,
        tenant=resource.name,
        servicePath=resource.path)


@router.get("/resources",
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


@router.get("/resources/mine",
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


@router.get("/policies",
            response_model=List[sp.Policy],
            summary="List policies for a given resource")
def read_policies(
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(None),
        resource: Optional[str] = None,
        resource_type: Optional[str] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    db_policies = operations.get_policies(
        db,
        tenant=fiware_service,
        service_path=fiware_servicepath,
        resource=resource,
        resource_type=resource_type,
        skip=skip,
        limit=limit)
    policies = []
    for db_policy in db_policies:
        policies.append(rp.serialize_policy(db_policy))
    return policies


@router.get("/policies/{policy_id}", response_model=sp.Policy,
            summary="Get a policy")
def read_policy(
        policy_id: str,
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            None),
        db: Session = Depends(get_db)):
    db_service_path = None
    if fiware_service:
        db_service_path = ot.get_db_service_path(
            db, fiware_service, fiware_servicepath)
    db_policy = op.get_policy(db, policy_id=policy_id)
    if not db_policy or (
            db_service_path and db_service_path[0].id != db_policy.service_path_id):
        raise HTTPException(status_code=404, detail="Policy not found")
    return rp.serialize_policy(db_policy)


@router.post("/policies",
             response_class=Response,
             status_code=status.HTTP_201_CREATED,
             summary="Create a policy for a given Tenant and Service Path")
def create_policy(
        response: Response,
        policy: sp.PolicyCreate,
        owner: Optional[str] = Header(
            None),
        fiware_service: Optional[str] = Header(
            None),
        fiware_servicepath: Optional[str] = Header(
            '/'),
        db: Session = Depends(get_db)):
    if policy.resource_type == "tenant" and policy.access_to != fiware_service:
        raise HTTPException(
            status_code=422,
            detail="access_to field needs to be the same as fiware_service when using type tenant")
    db_service_path_id = None
    # if we are asked for specific service and service path we comply
    # this is the case for private distribution
    if fiware_service:
        try:
            db_service_path = ot.get_db_service_path(
                db, fiware_service, fiware_servicepath)
        except Exception:
            logging.warning(
                "Cannot find tenant {}. We will create a new one".format(fiware_service))
            try:
                tid = ot.create_tenant(db, st.TenantCreate(fiware_service))
                new_service_path = st.ServicePathCreate(path=fiware_service)
                ot.create_tenant_service_path(
                    db, tenant_id=tid, service_path=new_service_path)
            except Exception as e:
                # When several notifications are sent at the same time
                # it can happen that the tenant is created meanwhile
                db_service_path = ot.get_db_service_path(
                    db, fiware_service, fiware_servicepath)
        db_service_path_id = list(map(ot.compute_id, db_service_path))
    # in case of public distribution, we check if there is already a
    # a corresponding registered resource in the database and use
    # the resource service and service path. if not we use `Default` service
    else:
        resources = operations.get_resources(
            db,
            tenant=None,
            service_path=None,
            resource=policy.access_to,
            resource_type=policy.resource_type,
            owner=owner)
        if resources and hasattr(resources, "__len__") and len(resources) > 0:
            db_service_path = ot.get_db_service_path(
                db, resources[0].name, resources[0].path)
            db_service_path_id = list(map(ot.compute_id, db_service_path))
            if len(resources) != 1:
                logging.warning(
                    "While looking for a resource we found multiple instances in different tenants. "
                    "We pick only the first one.")
        else:
            try:
                db_service_path = ot.get_db_service_path(db, 'Default', '/')
            except Exception as e:
                logging.warning(
                    "Cannot find tenant {}. We will create a new one".format('Default'))
                try:
                    ot.create_tenant(db, st.TenantCreate(name='Default'))
                    db_service_path = ot.get_db_service_path(
                        db, 'Default', '/')
                except Exception as e:
                    # When several notifications are sent at the same time
                    # it can happen that the tenant is created meanwhile
                    db_service_path = ot.get_db_service_path(
                        db, 'Default', '/')
            db_service_path_id = list(map(ot.compute_id, db_service_path))
            if owner:
                owner_policy = sp.PolicyCreate(
                    access_to=policy.access_to,
                    resource_type=policy.resource_type,
                    mode=['acl:Control'],
                    agent=[owner])
                op.create_policy(
                    db,
                    service_path_id=db_service_path_id,
                    policy=owner_policy)
    access_to: str
    resource_type: str
    policies = []
    for agent in policy.agent:
        for mode in policy.mode:
            db_policies = op.get_policies_by_service_path(
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
    policy_id = op.create_policy(
        db=db, service_path_id=db_service_path_id[0], policy=policy).id
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_201_CREATED
    return response


@router.put("/policies/{policy_id}",
            response_class=Response,
            status_code=status.HTTP_204_NO_CONTENT,
            summary="Update a policy for a given Tenant and Service Path")
def update(
        response: Response,
        policy_id: str,
        policy: sp.PolicyCreate,
        db: Session = Depends(get_db)):
    db_policy = op.get_policy(db, policy_id=policy_id)
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    policies = []
    for agent in policy.agent:
        for mode in policy.mode:
            db_policies = op.get_policies_by_service_path(
                db=db,
                tenant=None,
                service_path_id=[db_policy.service_path_id],
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
    response.headers["Policy-ID"] = op.update_policy(
        db=db, policy_id=policy_id, policy=policy)
    response.status_code = status.HTTP_204_NO_CONTENT
    return response


@router.delete("/policies/{policy_id}",
               response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT,
               summary="Delete a policy for a given Tenant and Service Path")
def delete_policy(
        response: Response,
        policy_id: str,
        db: Session = Depends(get_db)):
    db_policy = op.get_policy(db, policy_id=policy_id)
    if not db_policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    op.delete_policy(db=db, policy=db_policy)
    response.headers["Policy-ID"] = policy_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response
