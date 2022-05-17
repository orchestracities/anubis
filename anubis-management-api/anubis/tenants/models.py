from sqlalchemy import Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship, backref

from ..database import Base, autocommit_engine


class Tenant(Base):
    __tablename__ = "tenants"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    # on resource creation, we should identify the owner
    owner = Column(String, index=True, nullable=True)
    service_paths = relationship(
        "ServicePath",
        cascade="all, delete",
        back_populates="tenant")

# TODO cascade delete not working!!!!


class ServicePath(Base):
    __tablename__ = "service_paths"

    id = Column(String, primary_key=True, index=True)
    # on resource creation, we should identify the owner
    owner = Column(String, index=True, nullable=True)
    # ideally compute path using "back tracking of the hierarchy"
    path = Column(String, index=True)
    scope = Column(String, index=True)
    tenant_id = Column(String, ForeignKey("tenants.id", ondelete="CASCADE"))
    tenant = relationship("Tenant", back_populates="service_paths")
#   policies = relationship("Policy")
    parent_id = Column(
        String,
        ForeignKey(
            'service_paths.id',
            ondelete="CASCADE"),
        nullable=True)
    parent = relationship("ServicePath",
                          backref=backref('children', cascade="all, delete"),
                          remote_side=[id]
                          )
#ServicePath.parent_id = Column(String, ForeignKey(ServicePath.id), nullable=True)
#ServicePath.children = relationship(ServicePath, cascade = "all, delete")


def init_db():
    Base.metadata.create_all(bind=autocommit_engine)
