from sqlalchemy.orm import Session

from . import models, schemas
from policies import schemas as policy_schemas
from policies import operations as policy_operations
import uuid
import yaml


def get_tenant(db: Session, tenant_id: str):
    return db.query(
        models.Tenant).filter(
        models.Tenant.id == tenant_id).first()


def get_tenant_by_name(db: Session, name: str):
    return db.query(models.Tenant).filter(models.Tenant.name == name).first()


def get_tenants(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Tenant).offset(skip).limit(limit).all()


def create_tenant(db: Session, tenant: schemas.TenantCreate):
    new_tenant = models.Tenant(id=str(uuid.uuid4()), name=tenant.name)
    # there is always a `/` path
    service_path = schemas.ServicePathCreate(path='/')
    default_service_path = create_tenant_service_path(
        db=db,
        service_path=service_path,
        tenant_id=new_tenant.id,
        parent_id=None,
        scope=None)
    db.add(new_tenant)
    db.add(default_service_path)
    db.commit()
    db.refresh(new_tenant)
    # creating default policy
    # TODO: This will eventually read from a non yaml file
    with open(r'default_policies.yml') as file:
        default_policies = yaml.load(file, Loader=yaml.FullLoader)
        for p in default_policies["acl:Authorization"]:
            policy = policy_schemas.PolicyCreate(
                access_to=p["acl:accessTo"]["value"],
                resource_type=p["acl:accessTo"]["type"],
                mode=p["acl:mode"],
                agent=p["acl:agentClass"])
            policy_operations.create_policy(
                db=db, service_path_id=default_service_path.id, policy=policy)
    return new_tenant


def delete_tenant(db: Session, tenant: models.Tenant):
    db.delete(tenant)
    db.commit()


def get_service_paths(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.ServicePath).offset(skip).limit(limit).all()


def get_tenant_service_paths(
        db: Session,
        tenant_id: str,
        skip: int = 0,
        limit: int = 100):
    return db.query(models.ServicePath).filter(
        models.ServicePath.tenant_id == tenant_id).offset(skip).limit(limit).all()


def get_tenant_service_path_by_path(db: Session, tenant_id: str, path: str):
    return db.query(
        models.ServicePath).filter(
        models.ServicePath.tenant_id == tenant_id).filter(
            models.ServicePath.path == path).first()


def get_tenant_service_path(db: Session, service_path_id: str, tenant_id: str):
    return db.query(
        models.ServicePath).filter(
        models.ServicePath.tenant_id == tenant_id).filter(
            models.ServicePath.id == service_path_id).first()


def get_service_path_by_id(db: Session, service_path_id: str):
    return db.query(models.ServicePath).filter(
        models.ServicePath.id == service_path_id).first()


def create_tenant_service_path(
        db: Session,
        service_path: schemas.ServicePathCreate,
        tenant_id: str,
        parent_id: str,
        scope: str):
    db_service_path = models.ServicePath(
        **service_path.dict(),
        id=str(
            uuid.uuid4()),
        tenant_id=tenant_id,
        parent_id=parent_id,
        scope=scope)
    db.add(db_service_path)
    db.commit()
    db.refresh(db_service_path)
    return db_service_path


def delete_service_path(db: Session, service_path: models.ServicePath):
    db.delete(service_path)
    db.commit()
