from ..database import Base
from ..database import autocommit_engine
from ..tenants import models as t_models
from ..policies import models as p_models
import pytest


@pytest.fixture()
def test_db():
    Base.metadata.create_all(bind=autocommit_engine)
    yield
    Base.metadata.drop_all(bind=autocommit_engine)
