from fastapi.testclient import TestClient

from main import app
from .utils import test_db

client = TestClient(app)


def test_policies(test_db):
    response = client.post(
        "/v1/tenants/",
        json={"name": "test"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware_service": "test",
            "fiware_service_path": "/"},
        json={
            "access_to": "resource",
            "resource_type": "entity",
            "mode": ["acl:Read"],
            "agent": ["acl:agent:test"]})
    assert response.status_code == 201
    policy_id = response.headers["Policy-ID"]
    assert policy_id

    response = client.get(
        "/v1/policies/",
        headers={
            "fiware_service": "test",
            "fiware_service_path": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 1

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "fiware_service": "test",
            "fiware_service_path": "/"})
    body = response.json()
    assert response.status_code == 200
    assert body["access_to"] == "resource"
    assert body["resource_type"] == "entity"
    assert body["mode"] == ["acl:Read"]
    assert body["agent"] == ["acl:agent:test"]

    response = client.get(
        "/v1/policies/",
        headers={
            "accept": "text/rego",
            "fiware_service": "test",
            "fiware_service_path": "/"})
    body = response.json()
    assert response.status_code == 200
    assert body["user_permissions"]["test"][0] == {
        "action": "acl:Read",
        "resource": "resource",
        "resource_type": "entity",
        "service_path": "/",
        "tenant": "test"}

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "accept": "text/turtle",
            "fiware_service": "test",
            "fiware_service_path": "/"})
    assert response.status_code == 200

    response = client.delete(
        "/v1/policies/" + policy_id,
        headers={
            "fiware_service": "test",
            "fiware_service_path": "/"})
    assert response.status_code == 204
