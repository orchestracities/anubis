from fastapi.testclient import TestClient

from ..main import app
from .utils import test_db
from rdflib import Graph, URIRef, BNode, Literal
from rdflib import Namespace

client = TestClient(app)


def test_policies(test_db):
    response = client.post(
        "/v1/tenants/",
        json={"name": "Tenant1"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

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
    assert len(body) == 8

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
    assert len(body) == 1

    response = client.get(
        "/v1/policies/?resource_type=entity",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert len(body) == 7

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
    assert len(body) == 1

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
        "/v1/policies/" + policy_id,
        headers={
            "accept": "text/rego",
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    body = response.json()
    assert response.status_code == 200
    assert "acl:Write" in body["user_permissions"]["test"][0].values()
    assert "resource" in body["user_permissions"]["test"][0].values()
    assert "entity" in body["user_permissions"]["test"][0].values()
    assert "/" in body["user_permissions"]["test"][0].values()
    assert "test" in body["user_permissions"]["test"][0].values()

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"},
        json={
            "access_to": "resource",
            "resource_type": "entity",
            "mode": ["acl:Read"],
            "agent": ["acl:agent:test"]})
    assert response.status_code == 201
    policy_id = response.headers["policy-id"]

    response = client.delete(
        "/v1/policies/" + policy_id,
        headers={
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"})
    assert response.status_code == 204