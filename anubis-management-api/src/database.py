from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

database_type = os.environ.get('DATABASE_TYPE', "sqlite")

if database_type == "postgres":
    database_host = os.environ.get('POSTGRES_HOST', "localhost")
    database_user = os.environ.get('POSTGRES_USER', "admin")
    database_password = os.environ.get('POSTGRES_PASSWORD', "password")
    database_name = os.environ.get('POSTGRES_DB', "anubis")

    SQLALCHEMY_DATABASE_URL = "postgresql://{}:{}@{}/{}".format(database_user, database_password, database_host, database_name)

    engine = create_engine(
        SQLALCHEMY_DATABASE_URL
    )
else:
    SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"

    engine = create_engine(
        SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
    )

# connect_args={"check_same_thread": False} is required only for sqlite!

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
