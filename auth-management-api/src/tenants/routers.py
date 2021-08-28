from typing import List
from fastapi import Depends, APIRouter, HTTPException, status, Response
from . import operations, models, schemas
from dependencies import get_db
from database import engine
from sqlalchemy.orm import Session

models.Base.metadata.create_all(bind=engine)

router = APIRouter(prefix="/v1/tenants",
    tags=["services"],
    responses={404: {"description": "Not found"}},)


@router.get("/service_paths", response_model=List[schemas.ServicePath])
def read_service_paths(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    service_paths = operations.get_service_paths(db, skip=skip, limit=limit)
    return service_paths


@router.get("/", response_model=List[schemas.Tenant])
async def read_tenants(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    services = operations.get_tenants(db, skip=skip, limit=limit)
    return services


@router.post("/", response_class = Response, status_code = status.HTTP_201_CREATED)
def create_tenant(response: Response, tenant: schemas.TenantCreate, db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant_by_name(db, name=tenant.name)
    if db_tenant:
        raise HTTPException(status_code=400, detail="Tenant already registered")
    tenant_id = operations.create_tenant(db=db, tenant=tenant).id
    response.headers["Tenant-ID"] = tenant_id
    response.status_code = status.HTTP_201_CREATED
    return response


@router.get("/{tenant_id}", response_model=schemas.Tenant)
def read_tenant(tenant_id: str, db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if db_tenant is None:
        raise HTTPException(status_code=404, detail="Tenant not found")
    return db_tenant

#TODO
# @router.put("/{tenant_id}", response_model=schemas.Tenant)


@router.delete("/{tenant_id}", response_class = Response, status_code = status.HTTP_204_NO_CONTENT)
def delete_service(response: Response, tenant_id: str, db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    operations.delete_tenant(db=db, tenant = db_tenant)
    response.headers["Tenant-ID"] = tenant_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response


@router.post("/{tenant_id}/service_paths", response_class = Response, status_code = status.HTTP_201_CREATED)
def create_service_path(response: Response, tenant_id: str, service_path: schemas.ServicePathCreate, db: Session = Depends(get_db)):
    service_path_parent_index = service_path.path.rfind('/')
    service_path_parent_id = None
    scope = None
    if service_path_parent_index >= 0:
        if service_path_parent_index == 0:
            service_path_parent = '/'
            if service_path_parent_index != len(service_path.path)-1:
                scope = service_path.path[service_path_parent_index+1:]
        else:
            print("else service_path_parent_index == 0 and service_path_parent_index+1 != len(service_path.path)")
            service_path_parent = service_path.path[:service_path_parent_index]
            scope = service_path.path[service_path_parent_index+1:]
        db_service_path_parent = operations.get_tenant_service_path_by_path(db, tenant_id=tenant_id, path=service_path_parent)
        if not db_service_path_parent:
            raise HTTPException(status_code=404, detail="The service path parent {} not found. Service subpath cannot be created".format(service_path_parent))
        service_path_parent_id = db_service_path_parent.id
    db_service_path = operations.get_tenant_service_path_by_path(db, tenant_id=tenant_id, path=service_path.path)
    if db_service_path:
        raise HTTPException(status_code=400, detail="ServicePath already registered")
    service_path_id = operations.create_tenant_service_path(db=db, service_path=service_path, tenant_id=tenant_id, parent_id=service_path_parent_id, scope=scope).id
    response.headers["Service-Path-ID"] = service_path_id
    response.status_code = status.HTTP_201_CREATED
    return response


@router.get("/{tenant_id}/service_paths", response_model=List[schemas.ServicePath])
def read_tenant_service_paths(tenant_id: str, skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    service_paths = operations.get_tenant_service_paths(db, tenant_id=tenant_id, skip=skip, limit=limit)
    return service_paths


@router.get("/{tenant_id}/service_paths/{service_path_id}", response_model=schemas.ServicePath)
def read_service_path(tenant_id: str, service_path_id: str, db: Session = Depends(get_db)):
    service_path = operations.get_tenant_service_path(db, service_path_id=service_path_id, tenant_id=tenant_id)
    return service_path

# TODO how to handle changes on the tree? either path is dynamically computed, or this is cumbersome
# https://docs.sqlalchemy.org/en/14/orm/extensions/hybrid.html 
# https://groups.google.com/g/sqlalchemy/c/8z0XGRMDgCk
# @router.put("/{tenant_id}/service_paths/{service_path_id}", response_model=schemas.ServicePath)


@router.delete("/{tenant_id}/service_paths/{service_path_id}", response_class = Response, status_code = status.HTTP_204_NO_CONTENT)
def delete_service_path(response: Response, tenant_id: str, service_path_id: str, db: Session = Depends(get_db)):
    db_service_path = operations.get_tenant_service_path(db, service_path_id=service_path_id, tenant_id=tenant_id)
    if not db_service_path:
        raise HTTPException(status_code=404, detail="ServicePath not found")
    if db_service_path.path == '/':
        raise HTTPException(status_code=400, detail="You cannot delete root path")
    operations.delete_service_path(db=db, service_path = db_service_path)
    response.headers["Service-Path-ID"] = service_path_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response