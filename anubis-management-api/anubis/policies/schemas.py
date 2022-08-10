from __future__ import annotations
from typing import List, Optional
from pydantic import BaseModel, ValidationError, validator
from rfc3987 import parse
import re
import anubis.default as default
import uuid


class ModeBase(BaseModel):
    iri: str


class ModeCreate(ModeBase):
    name: str
    pass


class Mode(ModeBase):
    name: str

    class Config:
        orm_mode = True


class PolicyBase(BaseModel):
    id: Optional[str] = None
    access_to: str
    resource_type: str
    mode: List[str] = []
    agent: List[str] = []
    # agent iri (unless pre-defined) are agent_type_iri:id

    @validator('id')
    def valid_id(cls, id):
        if not id:
            return str(uuid.uuid4())
        return id

    @validator('agent')
    def valid_agent(cls, agent, values):
        if agent is None or agent == []:
            raise ValueError('you need to pass at least one agent')
        for a in agent:
            if a not in default.DEFAULT_AGENTS and not re.match(
                    default.AGENT_IRI_REGEX, a):
                raise ValueError(
                    'invalid agent identifier: {}. valid idenfiers are {} or agent_type_iri:id'.format(
                        a, default.DEFAULT_AGENTS))
            if len(a) > 255:
                raise ValueError('max agent iri lenght is 255 characters')
        return agent

    @validator('mode')
    def valid_mode(cls, mode):
        if mode is None or mode == []:
            raise ValueError('you need to pass at least one mode')
        for m in mode:
            if m not in default.DEFAULT_MODES:
                raise ValueError(
                    'invalid mode identifier: {}. valid idenfiers are {}'.format(
                        m, default.DEFAULT_MODES))
        return mode

    @validator('access_to')
    def valid_iri(cls, access_to):
        parse(access_to)
        return access_to

    @validator('resource_type')
    def valid_resource_type(cls, resource_type, values):
        parse(resource_type, rule='relative_part')
        return resource_type


class PolicyCreate(PolicyBase):
    pass


class Policy(PolicyBase):
    id: str

    class Config:
        orm_mode = True


Policy.update_forward_refs()


class AgentBase(BaseModel):
    iri: str
    type: str


class AgentCreate(AgentBase):
    pass


class Agent(AgentBase):

    class Config:
        orm_mode = True


class AgentTypeBase(BaseModel):
    iri: str
    name: str


class AgentTypeCreate(AgentTypeBase):
    pass


class AgentType(AgentTypeBase):

    class Config:
        orm_mode = True
