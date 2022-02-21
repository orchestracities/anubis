from sqlalchemy.orm import Session

from . import models, schemas
import uuid
import default


def get_policy(db: Session, policy_id: str):
    return db.query(
        models.Policy).filter(
        models.Policy.id == policy_id).first()


def get_policies_by_service_path(
        db: Session,
        service_path_id: str,
        mode: str = None,
        agent: str = None,
        skip: int = 0,
        limit: int = 100):
    if mode is not None and agent is not None:
        return db.query(
            models.Policy).join(
            models.Policy.agent).filter(
            models.Agent.iri == agent).join(
                models.Policy.mode).filter(
                    models.Mode.iri == mode).filter(
                        models.Policy.service_path_id == service_path_id).offset(skip).limit(limit).all()
    elif mode is None and agent is not None:
        return get_policies_by_agent(
            db=db,
            service_path_id=service_path_id,
            agent=agent,
            skip=skip,
            limit=limit)
    elif mode is not None and agent is None:
        return get_policies_by_mode(
            db=db,
            service_path_id=service_path_id,
            mode=mode,
            skip=skip,
            limit=limit)
    else:
        return _get_policies_by_service_path(
            db=db, service_path_id=service_path_id, skip=skip, limit=limit)


def get_policies_by_mode(
        db: Session,
        service_path_id: str,
        mode: str,
        skip: int = 0,
        limit: int = 100):
    return db.query(
        models.Policy).join(
        models.Policy.mode).filter(
            models.Mode.iri == mode).filter(
                models.Policy.service_path_id == service_path_id).offset(skip).limit(limit).all()


def get_policies_by_agent(
        db: Session,
        service_path_id: str,
        agent: str,
        skip: int = 0,
        limit: int = 100):
    return db.query(
        models.Policy).join(
        models.Policy.agent).filter(
            models.Agent.iri == agent).filter(
                models.Policy.service_path_id == service_path_id).offset(skip).limit(limit).all()


def _get_policies_by_service_path(
        db: Session,
        service_path_id: str,
        skip: int = 0,
        limit: int = 100):
    return db.query(
        models.Policy).filter(
        models.Policy.service_path_id == service_path_id).offset(skip).limit(limit).all()


def get_policy_by_access_to(db: Session, access_to: str):
    return db.query(models.Policy).filter(models.Policy.access_to == access_to)


def get_policies(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Policy).offset(skip).limit(limit).all()


def create_policy(
        db: Session,
        service_path_id: str,
        policy: schemas.PolicyCreate):
    db_policy = models.Policy(
        id=str(
            uuid.uuid4()),
        access_to=policy.access_to,
        resource_type=policy.resource_type,
        service_path_id=service_path_id)
    db.add(db_policy)
    for mode in policy.mode:
        db_mode = get_mode_by_iri(db, mode)
        db.execute(models.policy_to_mode.insert().values(
            [(db_policy.id, db_mode.iri)]))
    for agent in policy.agent:
        db_agent = get_agent_by_iri(db, agent)
        if not db_agent:
            db_agent = create_agent(db, agent)
        db.execute(models.policy_to_agent.insert().values(
            [(db_policy.id, db_agent.iri)]))
    db.commit()
    db.refresh(db_policy)
    return db_policy


def delete_policy(db: Session, policy: schemas.PolicyCreate):
    db.delete(policy)
    db.commit()


def get_mode_by_iri(db: Session, mode_iri: str):
    return db.query(models.Mode).filter(models.Mode.iri == mode_iri).first()


def get_agent_by_iri(db: Session, agent_iri: str):
    return db.query(models.Agent).filter(models.Agent.iri == agent_iri).first()


def get_agents(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Agent).offset(skip).limit(limit).all()


def get_agents_by_type(
        db: Session,
        agent_type_iri: str,
        skip: int = 0,
        limit: int = 100):
    return db.query(models.Agent).filter(models.Agent.type ==
                                         agent_type_iri).offset(skip).limit(limit).all()


def create_agent(db: Session, agent_iri: str):
    # default agent are created on db instantiation
    agent_type = agent_iri[:agent_iri.index(":", 4)]
    db_agent = models.Agent(iri=agent_iri, type=agent_type)
    db.add(db_agent)
    db.commit()
    db.refresh(db_agent)
    return db_agent


def get_modes(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Mode).offset(skip).limit(limit).all()


def get_agent_types(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.AgentType).offset(skip).limit(limit).all()
