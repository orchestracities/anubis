from fastapi.testclient import TestClient

from ..main import app
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

    response = client.get("/v1/tenants/" + tenant_id)
    body = response.json()
    assert response.status_code == 200
    assert body["name"] == "test"

    response = client.delete("/v1/tenants/" + tenant_id)
    assert response.status_code == 204


def test_service_paths(test_db):
    response = client.post(
        "/v1/tenants/",
        json={"name": "test"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.get("/v1/tenants/" + tenant_id + "/service_paths/")
    body = response.json()
    assert response.status_code == 200
    assert body[0]["path"] == "/"

    response = client.post(
        "/v1/tenants/" + tenant_id + "/service_paths",
        json={"path": "/foobar"}
    )
    assert response.status_code == 201
    service_path_id = response.headers["Service-Path-ID"]
    assert service_path_id

    response = client.post(
        "/v1/tenants/" + tenant_id + "/service_paths",
        json={"path": "/foobar/barbar"}
    )
    assert response.status_code == 201
    service_path_id = response.headers["Service-Path-ID"]
    assert service_path_id

    response = client.get("/v1/tenants/" + tenant_id + "/service_paths/")
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 3

    response = client.get(
        "/v1/tenants/" +
        tenant_id +
        "/service_paths/?name=/foobar/barbar")
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 1

    response = client.get(
        "/v1/tenants/" +
        tenant_id +
        "/service_paths/?name=/foobar")
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 2

    response = client.get(
        "/v1/tenants/" +
        tenant_id +
        "/service_paths/" +
        service_path_id)
    body = response.json()
    assert response.status_code == 200
    assert body["path"] == "/foobar/barbar"
    assert body["tenant_id"] == tenant_id

    response = client.delete(
        "/v1/tenants/" +
        tenant_id +
        "/service_paths/" +
        service_path_id)
    assert response.status_code == 204
