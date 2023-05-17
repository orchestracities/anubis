from sqlalchemy import Table, Boolean, Column, ForeignKey, Integer, String, UniqueConstraint, ForeignKeyConstraint
from sqlalchemy.orm import relationship, column_property

from ..database import autocommit_engine, Base, SessionLocal
from sqlalchemy import event, select, func
from ..tenants.models import ServicePath, Tenant
from ..rego import serialize as r_serialize
from uuid import uuid4

import anubis.default as default
import json
import requests
import os


policy_to_mode = Table(
    'policy_to_mode', Base.metadata, Column(
        'policy_id', String, ForeignKey(
            'policies.id', onupdate="CASCADE", ondelete="CASCADE")), Column(
                'mode_iri', String, ForeignKey(
                    'modes.iri', onupdate="CASCADE", ondelete="CASCADE")))


policy_to_agent = Table(
    'policy_to_agent', Base.metadata, Column(
        'policy_id', String, ForeignKey(
            'policies.id', onupdate="CASCADE", ondelete="CASCADE")), Column(
                'agent_iri', String, ForeignKey(
                    'agents.iri', onupdate="CASCADE", ondelete="CASCADE")))


class Policy(Base):
    __tablename__ = "policies"

    id = Column(String, primary_key=True, default=uuid4, index=True)
    agent = relationship("Agent", secondary=policy_to_agent)
    access_to = Column(String, index=True)
    resource_type = Column(String, index=True)
    mode = relationship("Mode", secondary=policy_to_mode)
    constraint = Column(String, index=True)
    service_path = relationship(ServicePath)
    service_path_id = Column(
        String,
        ForeignKey(
            'service_paths.id',
            ondelete="CASCADE"))


class AgentType(Base):
    __tablename__ = "agent_types"

    iri = Column(String, primary_key=True, index=True)
    name = Column(String, index=True, unique=True)


class Agent(Base):
    __tablename__ = "agents"

    iri = Column(String, primary_key=True, index=True)
    type = relationship(AgentType)
    type_iri = Column(String, ForeignKey(AgentType.iri))


class Mode(Base):
    __tablename__ = "modes"

    iri = Column(String, primary_key=True, index=True)
    name = Column(String, index=True, unique=True)


def init_db():
    Base.metadata.create_all(bind=autocommit_engine)


def drop_db():
    Base.metadata.drop_all(bind=autocommit_engine)


def update_policies_in_opa():
    if os.environ.get('OPA_ENDPOINT') and os.environ.get(
            'HOURLY_OPA_POLICIES_REFRESH') == "True":
        opa_url = os.environ.get('OPA_ENDPOINT')
        db = SessionLocal()
        tenants = db.query(Tenant).all()
        for tenant in tenants:
            db_service_paths = db.query(ServicePath).filter(
                ServicePath.tenant_id == tenant.id).all()
            policies = []
            for db_service_path in db_service_paths:
                path_policies = db.query(Policy).filter(
                    Policy.service_path_id.startswith(
                        db_service_path.id)).all()
                policies = policies + path_policies
            policies = r_serialize(db, policies)
            policies = json.loads(policies)
            # Not currently handling service paths
            try:
                res = requests.put(
                    opa_url +
                    "/v1/data/" +
                    tenant.name +
                    "/policies",
                    json=policies)
                if res.status_code != 204:
                    print("Failed scheduled update to policies in OPA")
            except BaseException:
                print("Failed scheduled update to policies in OPA")


@event.listens_for(AgentType.__table__, 'after_create')
def insert_initial_agent_type_values(target, connection, **kw):
    db = SessionLocal()
    db.add(AgentType(name='agent', iri=default.AGENT_IRI))
    db.add(AgentType(name='group', iri=default.AGENT_GROUP_IRI))
    db.add(AgentType(name='class', iri=default.AGENT_CLASS_IRI))
    db.commit()
    db.close()


@event.listens_for(Agent.__table__, 'after_create')
def insert_initial_agent_values(target, connection, **kw):
    db = SessionLocal()
    db.add(
        Agent(
            iri=default.AUTHENTICATED_AGENT_ID,
            type_iri=default.AGENT_CLASS_IRI))
    db.add(
        Agent(
            iri=default.UNAUTHENTICATED_AGENT_IRI,
            type_iri=default.AGENT_CLASS_IRI))
    db.commit()
    db.close()


@event.listens_for(Mode.__table__, 'after_create')
def insert_initial_mode_values(target, connection, **kw):
    db = SessionLocal()
    db.add(Mode(iri=default.READ_MODE_IRI, name='read'))
    db.add(Mode(iri=default.WRITE_MODE_IRI, name='write'))
    db.add(Mode(iri=default.CONTROL_MODE_IRI, name='control'))
    db.add(Mode(iri=default.APPEND_MODE_IRI, name='append'))
    db.add(Mode(iri=default.DELETE_MODE_IRI, name='delete'))
    db.commit()
    db.close()
