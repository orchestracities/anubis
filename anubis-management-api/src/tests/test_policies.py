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
            "fiware-service": "test",
            "fiware-servicepath": "/"},
        json={
            "access_to": "resource",
            "resource_type": "entity",
            "mode": ["acl:Read"],
            "agent": ["acl:agent:test"]})
    assert response.status_code == 201
    policy_id = response.headers["Policy-ID"]
    assert policy_id

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"},
        json={
            "access_to": "resource:foobar",
            "resource_type": "entity",
            "mode": ["acl:Read"],
            "agent": ["acl:agent:test"]})
    assert response.status_code == 201
    policy_id = response.headers["Policy-ID"]
    assert policy_id

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"},
        json={
            "access_to": "resource:foobar:bar",
            "resource_type": "entity",
            "mode": ["acl:Read"],
            "agent": ["acl:agent:test"]})
    assert response.status_code == 201
    policy_id = response.headers["Policy-ID"]
    assert policy_id

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"},
        json={
            "access_to": "resource",
            "resource_type": "entity",
            "mode": ["acl:Write"],
            "agent": ["acl:agent:test"]})
    assert response.status_code == 201
    policy_id = response.headers["Policy-ID"]
    assert policy_id

    response = client.get(
        "/v1/policies/",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    body = response.json()
    assert len(body) == 6

    response = client.get(
        "/v1/policies/?agent_type=acl:agent",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 4

    response = client.get(
        "/v1/policies/?agent_type=acl:agentGroup",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 0

    response = client.get(
        "/v1/policies/?resource_type=entity",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 4

    response = client.get(
        "/v1/policies/?resource_type=entity&&agent_type=acl:agent",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 4

    response = client.get(
        "/v1/policies/?resource_type=entity&&agent_type=acl:agentGroup",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 0

    response = client.get(
        "/v1/policies/?resource_type=entity&&agent_type=acl:agent&&resource=resource",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 4

    response = client.get(
        "/v1/policies/?resource_type=entity&&agent_type=acl:agent&&resource=resource:foobar",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 2

    response = client.get(
        "/v1/policies/?resource_type=subscription",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 0

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert body["access_to"] == "resource"
    assert body["resource_type"] == "entity"
    assert body["mode"] == ["acl:Write"]
    assert body["agent"] == ["acl:agent:test"]

    response = client.get(
        "/v1/policies/",
        headers={
            "accept": "text/rego",
            "fiware-service": "test",
            "fiware-servicepath": "/"})
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
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    assert response.status_code == 200

    response = client.delete(
        "/v1/policies/" + policy_id,
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    assert response.status_code == 204
