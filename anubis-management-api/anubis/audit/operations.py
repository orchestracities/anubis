from sqlalchemy.orm import Session
from fastapi import HTTPException
from . import models, schemas
from datetime import datetime

def get_logs_by_service_path(
    db: Session,
    service_path_id: str,
    user: str = None,
    resource: str = None,
    method: str = None,
    decision: str = None,
    type: str = None,
    service: str = None,
    fromDate: datetime = None,
    toDate: datetime = None,
    skip: int = 0,
    limit: int = 100,
    user_info: dict = None):
        db_logs = db.query(
            models.AccessLog).filter(
                        models.AccessLog.service_path_id.in_(service_path_id))
        if resource:
            db_logs = db_logs.filter(
                models.AccessLog.resource.contains(resource))
        if method:
            db_logs = db_logs.filter(
                models.AccessLog.method.contains(method))
        if user:
            db_logs = db_logs.filter(
                models.AccessLog.user.contains(user))
        if decision:
            db_logs = db_logs.filter(
                models.AccessLog.decision.contains(decision))
        if type:
            db_logs = db_logs.filter(
                models.AccessLog.type.contains(type))
        if service:
            db_logs = db_logs.filter(
                models.AccessLog.service.contains(service))
        if fromDate:
            db_logs = db_logs.filter(
                models.AccessLog.timestamp > fromDate)
        if toDate:
            db_logs = db_logs.filter(
                models.AccessLog.timestamp < toDate)
        if user_info:
            db_logs = None
        return db_logs.offset(skip).limit(limit).all()


def create_access_log(
        db: Session,
        access_log: schemas.AccessLogCreate,
        service_path_id: str):
    db_access_log = models.AccessLog(
        **access_log.dict(),
        service_path_id = service_path_id)
    db.add(db_access_log)
    db.commit()
    db.refresh(db_access_log)
    return db_access_log


def update_access_log(
        db: Session,
        access_log_id: str,
        access_log: schemas.AccessLogCreate):
    db.query(models.AccessLog).filter(models.AccessLog.id == access_log_id).update(
        {"type": access_log.type, "service": access_log.service, "resource": access_log.resource, "method": access_log.method, "decision": access_log.decision, "user": access_log.user, "remote_ip": access_log.remote_ip, "timestamp": access_log.timestamp })
    db.commit()
    return access_log_id