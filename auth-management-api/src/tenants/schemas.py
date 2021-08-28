from __future__ import annotations
from typing import List, Optional
from pydantic import BaseModel, ValidationError, validator
import re


class ServicePathBase(BaseModel):
    path: str

    @validator('path')
    def valid_service_path_name(cls, v):
        if not v.startswith('/'):
            raise ValueError('service path always starts with /')
        p = re.compile("^[a-zA-Z0-9_/]*$")
        scopes = v.split("/")
        for scope in scopes:
            if not p.match(scope):
                raise ValueError(
                    'each scope in a service path must include only alphanumeric or _ characters')
            if len(scope) > 50:
                raise ValueError(
                    'each scope in a service path max lenght is 50 characters')
        return v


class ServicePathCreate(ServicePathBase):
    pass


class ServicePath(ServicePathBase):
    id: str
    tenant_id: str
    parent_id: str = None
    scope: str = None
    children: List['ServicePath'] = []

    class Config:
        orm_mode = True


ServicePath.update_forward_refs()


class TenantBase(BaseModel):
    name: str

    @validator('name')
    def valid_tenant_name(cls, v):
        p = re.compile("^[a-zA-Z0-9_]*$")
        if not p.match(v):
            raise ValueError(
                'name must include only alphanumeric or _ characters')
        if len(v) > 50:
            raise ValueError('name max lenght is 50 characters')
        return v


class TenantCreate(TenantBase):
    pass


class Tenant(TenantBase):
    id: str
    service_paths: List[ServicePath] = []

    class Config:
        orm_mode = True
