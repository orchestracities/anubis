from pydantic import BaseModel


# TODO it would be good to have also the list of owners, but query needs
# to be defined
class ResourceBase(BaseModel):
    id: str
    type: str
    tenant: str
    servicePath: str


class Resource(ResourceBase):
    pass
