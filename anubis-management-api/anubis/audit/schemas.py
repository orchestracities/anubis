from __future__ import annotations
from typing import List, Optional
from pydantic import BaseModel, ValidationError, validator
from datetime import datetime
from rfc3987 import parse
import re
import anubis.default as default


class OpaDecisionLogBase(BaseModel):
    decision_id: str
    input: dict = None
    path: str = None
    labels: dict = None
    metrics: dict = None
    result: dict = None
    timestamp: datetime


class AccessLogBase(BaseModel):
    id: str
    type: str = None
    service: str = None
    resource: str = None
    method: str = None
    decision: str = None
    user: Optional[str] = None
    remote_ip: str = None
    timestamp: datetime


class AccessLogCreate(AccessLogBase):
    pass


class AccessLog(AccessLogBase):

    class Config:
        orm_mode = True


AccessLog.update_forward_refs()
