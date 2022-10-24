import logging

from sqlalchemy.orm import Session
from fastapi import HTTPException
from . import models, schemas
from ..policies import schemas as policy_schemas
from ..policies import operations as policy_operations
from rdflib import Graph, URIRef, BNode, Literal
from rdflib import Namespace
from ..wac import parse_rdf_graph as parse_rdf_graph
import uuid
import yaml
import os


def get_tenant(db: Session, tenant_id: str):
    return db.query(
        models.Tenant).filter(
        models.Tenant.id == tenant_id).first()


def get_tenant_by_name(db: Session, name: str):
    return db.query(models.Tenant).filter(models.Tenant.name == name).first()


def get_tenants(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Tenant).offset(skip).limit(limit).all()


def create_tenant(
        db: Session,
        tenant: schemas.TenantCreate,
        tenant_id: str = None):
    if not tenant_id:
        tenant_id = str(uuid.uuid4())
    new_tenant = models.Tenant(id=tenant_id, name=tenant.name)
    db.add(new_tenant)
    # there is always a `/` path
    service_path = schemas.ServicePathCreate(path='/')
    default_service_path = create_tenant_service_path(
        db=db,
        service_path=service_path,
        tenant_id=new_tenant.id,
        parent_id=None,
        scope=None)
    db.add(default_service_path)
    db.commit()
    db.refresh(new_tenant)
    # creating default policy
    try:
        with open(os.environ.get("DEFAULT_POLICIES_CONFIG_FILE", '../config/opa-service/default_policies.ttl'), 'r') as file:
            policies = parse_rdf_graph(file.read())
            for p in policies:
                policy = policy_schemas.PolicyCreate(
                    access_to=policies[p]["accessTo"],
                    resource_type=policies[p]["accessToClass"],
                    mode=[policies[p]["mode"]],
                    agent=[policies[p]["agentClass"]])
                policy_operations.create_policy(
                    db=db, service_path_id=default_service_path.id, policy=policy)
    except Exception as e:
        logging.error(e)
    return new_tenant


def delete_tenant(db: Session, tenant: models.Tenant):
    db.delete(tenant)
    db.commit()


def get_service_paths(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.ServicePath).offset(skip).limit(limit).all()


def get_tenant_service_paths(
        db: Session,
        tenant_id: str,
        name: str = None,
        skip: int = 0,
        limit: int = 100):
    db_service_paths = db.query(models.ServicePath).filter(
        models.ServicePath.tenant_id == tenant_id)
    if name:
        db_service_paths = db_service_paths.filter(
            models.ServicePath.path.startswith(name))
    return db_service_paths.offset(skip).limit(limit).all()


def get_db_service_path(db: Session, tenant: str, service_path: str):
    if not tenant:
        raise HTTPException(status_code=422, detail="Tenant cannot be None")
    db_tenant = get_tenant_by_name(db, name=tenant)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    db_service_path = get_tenant_service_path_by_path(
        db, tenant_id=db_tenant.id, path=service_path)
    if not db_service_path:
        raise HTTPException(status_code=404, detail="Service Path not found")
    return db_service_path


def get_tenant_service_path_by_path(db: Session, tenant_id: str, path: str):
    if path.endswith('/#'):
        queryPath = path.replace('#', '%')
        return db.query(
            models.ServicePath).filter(
            models.ServicePath.tenant_id == tenant_id).filter(
                models.ServicePath.path.like(queryPath)).all()
    else:
        return db.query(
            models.ServicePath).filter(
            models.ServicePath.tenant_id == tenant_id).filter(
                models.ServicePath.path == path).all()


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


def compute_id(service_path: models.ServicePath):
    return service_path.id
