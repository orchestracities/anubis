from fastapi.testclient import TestClient

from main import app
from .utils import test_db

client = TestClient(app)

def test_tenants(test_db):
    response = client.post(
        "/v1/tenants/",
        json={"name": "test"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.get("/v1/tenants/")
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 1

    response = client.get("/v1/tenants/"+tenant_id)
    body = response.json()
    assert response.status_code == 200
    assert body["name"] == "test"


def test_service_paths(test_db):
    response = client.post(
        "/v1/tenants/",
        json={"name": "test"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.get("/v1/tenants/"+tenant_id+"/service_paths/")
    body = response.json()
    assert response.status_code == 200
    assert body[0]["path"] == "/"

    response = client.post(
        "/v1/tenants/"+tenant_id+"/service_paths",
        json={"path": "/foobar"}
    )
    assert response.status_code == 201

    response = client.get("/v1/tenants/"+tenant_id+"/service_paths/")
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 2
