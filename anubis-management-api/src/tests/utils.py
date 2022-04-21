from database import Base
from database import engine
from tenants import models as t_models
from policies import models as p_models
import pytest


@pytest.fixture()
def test_db():
    Base.metadata.create_all(bind=engine)
    p_models.insert_initial_agent_type_values()
    p_models.insert_initial_mode_values()
    yield
    Base.metadata.drop_all(bind=engine)
