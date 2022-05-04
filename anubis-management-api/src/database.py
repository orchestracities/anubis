from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

database_type = os.environ.get('DB_TYPE', "sqlite")

if database_type == "postgres":
    database_host = os.environ.get('DB_HOST', "localhost")
    database_user = os.environ.get('DB_USER', "admin")
    database_password = os.environ.get('DB_PASSWORD', "password")
    database_name = os.environ.get('DB_NAME', "anubis")

    SQLALCHEMY_DATABASE_URL = "postgresql+pg8000://{}:{}@{}/{}".format(
        database_user, database_password, database_host, database_name)

    engine = create_engine(
        SQLALCHEMY_DATABASE_URL
    )
else:
    SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"

    engine = create_engine(
        SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
    )

autocommit_engine = engine.execution_options(isolation_level="AUTOCOMMIT")

SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)

Base = declarative_base()
