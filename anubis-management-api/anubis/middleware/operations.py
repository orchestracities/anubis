from sqlalchemy.orm import Session

import anubis.default as default
from ..policies import models as pm
from ..tenants import models as tm


# TODO it would be good to have also the list of owners, but query needs
# to be defined
def get_resources(
        db: Session,
        tenant: str = None,
        service_path: str = None,
        resource: str = None,
        resource_type: str = None,
        owner: str = None,
        skip: int = 0,
        limit: int = 100):
    db_policies = db.query(
        pm.Policy.access_to,
        pm.Policy.resource_type,
        tm.ServicePath.path,
        tm.Tenant.name).distinct().join(
        pm.Policy.mode).filter(
            pm.Mode.iri == default.CONTROL_MODE_IRI).join(
                pm.Policy.service_path).join(
        tm.ServicePath.tenant)
    if resource:
        db_policies = db_policies.filter(
            pm.Policy.access_to == resource)
    if resource_type:
        db_policies = db_policies.filter(
            pm.Policy.resource_type == resource_type)
    if tenant:
        db_policies = db_policies.filter(
            tm.Tenant.name == tenant)
    if service_path:
        db_policies = db_policies.filter(
            tm.ServicePath.path == service_path)
    if owner:
        db_policies = db_policies.join(
            pm.Policy.agent).filter(pm.Agent.iri == owner)
    return db_policies.offset(skip).limit(limit).all()


def get_policies(
        db: Session,
        tenant: str = None,
        service_path: str = None,
        resource: str = None,
        resource_type: str = None,
        skip: int = 0,
        limit: int = 100):
    db_policies = db.query(pm.Policy)
    if resource:
        db_policies = db_policies.filter(
            pm.Policy.access_to == resource)
    if resource_type:
        db_policies = db_policies.filter(
            pm.Policy.resource_type == resource_type)
    if tenant:
        db_policies = db_policies.join(pm.Policy.service_path).join(
            tm.ServicePath.tenant).filter(
            tm.Tenant.name == tenant)
    if service_path:
        db_policies = db_policies.join(pm.Policy.service_path).filter(
            tm.ServicePath.path == service_path)
    return db_policies.offset(skip).limit(limit).all()
