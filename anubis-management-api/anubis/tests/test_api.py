from fastapi.testclient import TestClient

from ..main import app
from ..version import ANUBIS_VERSION
from .utils import test_db

client = TestClient(app)


def test_root(test_db):
    response = client.get("/v1")
    assert response.status_code == 200
    body = response.json()
    assert body["tenants_url"] == "/v1/tenants"
    assert body["policies_url"] == "/v1/policies"
    assert body["audit_url"] == "/v1/audit"


def test_version(test_db):
    response = client.get("/version")
    assert response.status_code == 200
    body = response.json()
    assert body["version"] == ANUBIS_VERSION
