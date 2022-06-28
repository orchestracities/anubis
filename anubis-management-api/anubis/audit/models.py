from sqlalchemy import Column, ForeignKey, String, DateTime
from ..database import Base, autocommit_engine


class AuditLog(Base):
    __tablename__ = "audit_log"

    id = Column(String, primary_key=True, index=True)
    type = Column(String, index=True)
    service_path_id = Column(
        String,
        ForeignKey(
            'service_paths.id',
            ondelete="CASCADE"))
    service = Column(String, index=True)
    resource = Column(String, index=True)
    method = Column(String, index=True)
    decision = Column(String, index=True)
    # on resource creation, we should identify the owner
    user = Column(String, index=True, nullable=True)
    remote_ip = Column(String, index=True, nullable=True)
    timestamp = Column(DateTime, index=True)


def init_db():
    Base.metadata.create_all(bind=autocommit_engine)
