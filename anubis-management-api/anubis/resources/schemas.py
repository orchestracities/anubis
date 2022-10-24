from pydantic import BaseModel


class ResourceBase(BaseModel):
    id: str
    type: str
    tenant: str
    servicePath: str


class Resource(ResourceBase):
    pass
