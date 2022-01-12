from sqlalchemy import Table, Boolean, Column, ForeignKey, Integer, String, UniqueConstraint, ForeignKeyConstraint
from sqlalchemy.orm import relationship, column_property

from database import Base, SessionLocal
from sqlalchemy import event, select, func
from tenants.models import ServicePath
from uuid import uuid4

import default

# see https://github.com/solid/web-access-control-spec


policy_to_mode = Table('policy_to_mode', Base.metadata,
                       Column('policy_id', Integer, ForeignKey('policies.id')),
                       Column('mode_iri', Integer, ForeignKey('modes.iri'))
                       )


policy_to_agent = Table(
    'policy_to_agent', Base.metadata, Column(
        'policy_id', Integer, ForeignKey('policies.id')), Column(
            'agent_iri', Integer, ForeignKey('agents.iri')))


class Policy(Base):
    __tablename__ = "policies"

    id = Column(String, primary_key=True, default=uuid4, index=True)
    agent = relationship("Agent", secondary=policy_to_agent)
    access_to = Column(String, index=True)
    resource_type = Column(String, index=True)
    mode = relationship("Mode", secondary=policy_to_mode)
    service_path_id = Column(
        Integer,
        ForeignKey(
            'service_paths.id',
            ondelete="CASCADE"))


class Agent(Base):
    __tablename__ = "agents"

    iri = Column(String, primary_key=True, index=True)
    type = Column(Integer, index=True)


class Mode(Base):
    __tablename__ = "modes"

    iri = Column(String, primary_key=True, index=True)
    name = Column(String, index=True, unique=True)


class AgentType(Base):
    __tablename__ = "agent_types"

    iri = Column(String, primary_key=True, index=True)
    name = Column(String, index=True, unique=True)


@event.listens_for(AgentType.__table__, 'after_create')
def insert_initial_agent_type_values(*args, **kwargs):
    db = SessionLocal()
    db.add(AgentType(name='agent', iri=default.AGENT_IRI))
    db.add(AgentType(name='group', iri=default.AGENT_GROUP_IRI))
    db.add(AgentType(name='class', iri=default.AGENT_CLASS_IRI))
    db.commit()
    db.close()


@event.listens_for(Agent.__table__, 'after_create')
def insert_initial_agent_type_values(*args, **kwargs):
    db = SessionLocal()
    db.add(
        Agent(
            iri=default.AUTHENTICATED_AGENT_ID,
            type=default.AGENT_CLASS_IRI))
    db.add(
        Agent(
            iri=default.UNAUTHENTICATED_AGENT_IRI,
            type=default.AGENT_CLASS_IRI))
    db.commit()
    db.close()


@event.listens_for(Mode.__table__, 'after_create')
def insert_initial_mode_values(*args, **kwargs):
    db = SessionLocal()
    db.add(Mode(iri=default.READ_MODE_IRI, name='read'))
    db.add(Mode(iri=default.WRITE_MODE_IRI, name='write'))
    db.add(Mode(iri=default.CONTROL_MODE_IRI, name='control'))
    db.add(Mode(iri=default.APPEND_MODE_IRI, name='append'))
    db.commit()
    db.close()
