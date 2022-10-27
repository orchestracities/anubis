from typing import List, Optional
from fastapi import Depends, APIRouter, HTTPException, status, Response, Header
from . import operations, schemas
from ..dependencies import get_db
from sqlalchemy.orm import Session
import os
import requests
import json
from ..utils import OptionalHTTPBearer, parse_auth_token
import logging


auth_scheme = OptionalHTTPBearer()
router = APIRouter(prefix="/v1/tenants",
                   tags=["services"],
                   responses={404: {"description": "Not found"}},)


@router.get("/service_paths",
            response_model=List[schemas.ServicePath],
            summary="List all Service Paths")
def read_service_paths(
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    service_paths = operations.get_service_paths(db, skip=skip, limit=limit)
    return service_paths


@router.get("/",
            response_model=List[schemas.Tenant],
            summary="List all Tenants")
async def read_tenants(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    services = operations.get_tenants(db, skip=skip, limit=limit)
    return services


@router.post("/",
             response_class=Response,
             status_code=status.HTTP_201_CREATED,
             summary="Create a new Tenant")
def create_tenant(
        response: Response,
        tenant: schemas.TenantCreate,
        token: str = Depends(auth_scheme),
        db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant_by_name(db, name=tenant.name)
    if db_tenant:
        raise HTTPException(
            status_code=400,
            detail="Tenant already registered")

    keycloak_enabled = os.environ.get(
        'KEYCLOACK_ENABLED', 'False').lower() in (
        'true', '1', 't')
    tenant_admin_role_id = os.environ.get(
        'TENANT_ADMIN_ROLE_ID', '9dc79aa8-d42f-4720-8de0-fe79a00a46b7')
    db_tenant_id = None
    if keycloak_enabled and token:
        auth = "bearer " + token
        headers = {"Content-Type": "application/json", "Authorization": auth}
        api_url = os.environ.get(
            'KEYCLOACK_ADMIN_ENDPOINT',
            'http://localhost:8080/admin/realms/default')
        # get user from token
        user_info = parse_auth_token(token)
        user_id = user_info['sub']
        payload = {
            "name": tenant.name,
            "attributes": {
                "tenant": [
                    "true"
                ]
            }
        }

        try:
            # create tenant
            res = requests.post(
                api_url + "/groups", data=json.dumps(payload), headers=headers)
            if res.status_code != 201:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
            db_tenant_id = res.headers['location'][res.headers['location'].rindex(
                "/") + 1:]
            # add user to group
            # PUT / {realm} / users / {id} / groups / {groupId}
            res = requests.put(
                api_url +
                "/users/" +
                user_id +
                "/groups/" +
                db_tenant_id,
                headers=headers)
            if res.status_code != 204:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
            # create admin subgroup add user and set tenant-admin role
            if tenant_admin_role_id:
                # POST /{realm}/groups/{id}/children
                payload = {
                    "name": "Admin"
                }
                res = requests.post(
                    api_url +
                    "/groups/" +
                    db_tenant_id +
                    "/children",
                    data=json.dumps(payload),
                    headers=headers)
                if res.status_code != 201:
                    raise HTTPException(
                        status_code=res.status_code,
                        detail=res.text)
                admin_group_id = res.headers['location'][res.headers['location'].rindex(
                    "/") + 1:]
                # PUT / {realm} / users / {id} / groups / {groupId}
                res = requests.put(
                    api_url +
                    "/users/" +
                    user_id +
                    "/groups/" +
                    admin_group_id,
                    headers=headers)
                if res.status_code != 204:
                    raise HTTPException(
                        status_code=response.status_code,
                        detail=res.text)
                # POST / {realm} / groups / {groupId} / role-mappings / realm
                payload = [{
                    "name": "tenant-admin",
                    "id": tenant_admin_role_id
                }]
                res = requests.post(
                    api_url +
                    "/groups/" +
                    admin_group_id +
                    "/role-mappings/realm",
                    data=json.dumps(payload),
                    headers=headers)
                if res.status_code != 204:
                    raise HTTPException(
                        status_code=response.status_code,
                        detail=res.text)
            else:
                logging.warning("TENANT_ADMIN_ROLE_ID not defined")
        except HTTPException as e:
            raise HTTPException(
                status_code=e.status_code,
                detail=e.detail)
        except Exception as e:
            logging.debug(e)
            raise HTTPException(
                status_code=400,
                detail="Tenant creation failed with Keycloak")
    if keycloak_enabled and not token:
        raise HTTPException(
            status_code=401,
            detail="Token is missing: cannot authenticate with Keycloak")

    tenant_id = operations.create_tenant(
        db=db, tenant=tenant, tenant_id=db_tenant_id).id
    response.headers["Tenant-ID"] = tenant_id
    response.status_code = status.HTTP_201_CREATED
    return response


@router.get("/{tenant_id}",
            response_model=schemas.Tenant,
            summary="Get a Tenant")
def read_tenant(tenant_id: str, db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        db_tenant = operations.get_tenant_by_name(db, name=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    return db_tenant

# TODO
# @router.put("/{tenant_id}", response_model=schemas.Tenant)


@router.delete("/{tenant_id}",
               response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT,
               summary="Delete a Tenant")
def delete_service(
        response: Response,
        tenant_id: str,
        token: str = Depends(auth_scheme),
        db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        db_tenant = operations.get_tenant_by_name(db, name=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    keycloak_enabled = os.environ.get(
        'KEYCLOACK_ENABLED', 'False').lower() in (
        'true', '1', 't')
    if keycloak_enabled and token:
        auth = "bearer " + token
        headers = {"Content-Type": "application/json", "Authorization": auth}
        api_url = os.environ.get(
            'KEYCLOACK_ADMIN_ENDPOINT',
            'http://localhost:8080/admin/realms/default')
        try:
            # delete tenant
            res = requests.delete(
                api_url + "/groups/" + tenant_id, headers=headers)
            if res.status_code != 204:
                raise HTTPException(
                    status_code=res.status_code,
                    detail=res.text)
        except HTTPException as e:
            raise HTTPException(
                status_code=e.status_code,
                detail=e.detail)
        except Exception as e:
            logging.debug(e)
            raise HTTPException(
                status_code=400,
                detail="Tenant delete failed with Keycloak")
    if keycloak_enabled and not token:
        raise HTTPException(
            status_code=401,
            detail="Token is missing: cannot authenticate with Keycloak")
    operations.delete_tenant(db=db, tenant=db_tenant)
    response.headers["Tenant-ID"] = tenant_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response


@router.post("/{tenant_id}/service_paths",
             response_class=Response,
             status_code=status.HTTP_201_CREATED,
             summary="Create a new Service Path inside a Tenant")
def create_service_path(
        response: Response,
        tenant_id: str,
        service_path: schemas.ServicePathCreate,
        db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        db_tenant = operations.get_tenant_by_name(db, name=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    tenant_id = db_tenant.id
    service_path_parent_index = service_path.path.rfind('/')
    service_path_parent_id = None
    scope = None
    if service_path_parent_index >= 0:
        if service_path_parent_index == 0:
            service_path_parent = '/'
            if service_path_parent_index != len(service_path.path) - 1:
                scope = service_path.path[service_path_parent_index + 1:]
        else:
            print(
                "else service_path_parent_index == 0 and service_path_parent_index+1 != len(service_path.path)")
            service_path_parent = service_path.path[:service_path_parent_index]
            scope = service_path.path[service_path_parent_index + 1:]
        db_service_path_parent = operations.get_tenant_service_path_by_path(
            db, tenant_id=tenant_id, path=service_path_parent)
        if not db_service_path_parent:
            raise HTTPException(
                status_code=404,
                detail="The service path parent {} not found. Service subpath cannot be created".format(service_path_parent))
        service_path_parent_id = db_service_path_parent[0].id
    db_service_path = operations.get_tenant_service_path_by_path(
        db, tenant_id=tenant_id, path=service_path.path)
    if db_service_path:
        raise HTTPException(status_code=400,
                            detail="ServicePath already registered")
    service_path_id = operations.create_tenant_service_path(
        db=db,
        service_path=service_path,
        tenant_id=tenant_id,
        parent_id=service_path_parent_id,
        scope=scope).id
    response.headers["Service-Path-ID"] = service_path_id
    response.status_code = status.HTTP_201_CREATED
    return response


@router.get("/{tenant_id}/service_paths",
            response_model=List[schemas.ServicePath],
            summary="List Service Paths inside a Tenant")
def read_tenant_service_paths(
        tenant_id: str,
        name: Optional[str] = None,
        skip: int = 0,
        limit: int = 100,
        db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        db_tenant = operations.get_tenant_by_name(db, name=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    tenant_id = db_tenant.id
    service_paths = operations.get_tenant_service_paths(
        db,
        tenant_id=tenant_id,
        name=name,
        skip=skip,
        limit=limit)
    return service_paths


@router.get("/{tenant_id}/service_paths/{service_path_id}",
            response_model=schemas.ServicePath,
            summary="Get a Service Path inside a Tenant")
def read_service_path(
        tenant_id: str,
        service_path_id: str,
        db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        db_tenant = operations.get_tenant_by_name(db, name=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    tenant_id = db_tenant.id
    service_path = operations.get_tenant_service_path(
        db, service_path_id=service_path_id, tenant_id=tenant_id)
    # Federico commented these lines because he is not sure what's the purpose.
    # if not service_path:
    #    service_path = operations.get_tenant_service_path_by_path(
    #        db, tenant_id=tenant_id, path="/" + service_path_id)
    return service_path

# TODO how to handle changes on the tree? either path is dynamically computed, or this is cumbersome
# https://docs.sqlalchemy.org/en/14/orm/extensions/hybrid.html
# https://groups.google.com/g/sqlalchemy/c/8z0XGRMDgCk
# @router.put("/{tenant_id}/service_paths/{service_path_id}", response_model=schemas.ServicePath)


@router.delete("/{tenant_id}/service_paths/{service_path_id}",
               response_class=Response,
               status_code=status.HTTP_204_NO_CONTENT,
               summary="Delete a Service Path inside a Tenant")
def delete_service_path(
        response: Response,
        tenant_id: str,
        service_path_id: str,
        db: Session = Depends(get_db)):
    db_tenant = operations.get_tenant(db, tenant_id=tenant_id)
    if not db_tenant:
        db_tenant = operations.get_tenant_by_name(db, name=tenant_id)
    if not db_tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")
    tenant_id = db_tenant.id
    db_service_path = operations.get_tenant_service_path(
        db, service_path_id=service_path_id, tenant_id=tenant_id)
    # Federico commented these lines because he is not sure what's the purpose.
    # if not db_service_path:
    #     db_service_path = operations.get_tenant_service_path_by_path(
    #         db, tenant_id=tenant_id, path="/" + service_path_id)
    if not db_service_path:
        raise HTTPException(status_code=404, detail="ServicePath not found")
    if db_service_path.path == '/':
        raise HTTPException(
            status_code=400,
            detail="You cannot delete root path")
    operations.delete_service_path(db=db, service_path=db_service_path)
    response.headers["Service-Path-ID"] = service_path_id
    response.status_code = status.HTTP_204_NO_CONTENT
    return response
