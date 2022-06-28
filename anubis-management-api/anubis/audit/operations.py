from sqlalchemy.orm import Session
from fastapi import HTTPException
from . import models, schemas
from datetime import datetime


def get_logs_by_service_path(
        db: Session,
        service_path_id: str,
        user: str = None,
        resource: str = None,
        resource_type: str = None,
        mode: str = None,
        decision: str = None,
        type: str = None,
        service: str = None,
        fromDate: datetime = None,
        toDate: datetime = None,
        skip: int = 0,
        limit: int = 100,
        user_info: dict = None):
    db_logs = db.query(
        models.AuditLog).filter(
        models.AuditLog.service_path_id.in_(service_path_id))
    if resource:
        db_logs = db_logs.filter(
            models.AuditLog.resource.contains(resource))
    if resource_type:
        db_logs = db_logs.filter(
            models.AuditLog.resource_type.contains(resource_type))
    if mode:
        db_logs = db_logs.filter(
            models.AuditLog.mode.contains(mode))
    if user:
        db_logs = db_logs.filter(
            models.AuditLog.user.contains(user))
    if decision:
        db_logs = db_logs.filter(
            models.AuditLog.decision.contains(decision))
    if type:
        db_logs = db_logs.filter(
            models.AuditLog.type.contains(type))
    if service:
        db_logs = db_logs.filter(
            models.AuditLog.service.contains(service))
    if fromDate:
        db_logs = db_logs.filter(
            models.AuditLog.timestamp > fromDate)
    if toDate:
        db_logs = db_logs.filter(
            models.AuditLog.timestamp < toDate)
    if user_info:
        db_logs = None
    return db_logs.offset(skip).limit(limit).all()


def get_log_by_id_and_service_path(
        db: Session,
        audit_id: str,
        service_path_id: str,
        user_info: dict = None):
    db_logs = db.query(
        models.AuditLog).filter(
        models.AuditLog.service_path_id.in_(service_path_id)).filter(
        models.AuditLog.id == audit_id)
    return db_logs.first()


def create_audit_log(
        db: Session,
        audit_log: schemas.AuditLogCreate,
        service_path_id: str):
    db_audit_log = models.AuditLog(
        **audit_log.dict(),
        service_path_id=service_path_id)
    db.add(db_audit_log)
    db.commit()
    db.refresh(db_audit_log)
    return db_audit_log


def update_audit_log(
        db: Session,
        audit_log_id: str,
        audit_log: schemas.AuditLogCreate):
    db.query(
        models.AuditLog).filter(
        models.AuditLog.id == audit_log_id).update(
            {
                "type": audit_log.type,
                "service": audit_log.service,
                "resource": audit_log.resource,
                "resource_type": audit_log.resource_type,
                "mode": audit_log.mode,
                "decision": audit_log.decision,
                "user": audit_log.user,
                "remote_ip": audit_log.remote_ip,
                "timestamp": audit_log.timestamp})
    db.commit()
    return audit_log_id


def delete_log(db: Session, log: schemas.AuditLogCreate):
    db.delete(log)
    db.commit()
