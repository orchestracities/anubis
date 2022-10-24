from fastapi.testclient import TestClient

from ..main import app
from .utils import test_db
from rdflib import Graph, URIRef, BNode, Literal
from rdflib import Namespace
import os

client = TestClient(app)


def test_rdf_parsing(test_db):
    os.environ["DEFAULT_WAC_CONFIG_FILE"] = './anubis/tests/test_configs/test_wac_config.yml'
    os.environ["DEFAULT_POLICIES_CONFIG_FILE"] = './anubis/tests/test_configs/test_policies.ttl'

    response = client.post(
        "/v1/tenants/",
        json={"name": "Tenant1"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.post(
        "/v1/tenants/",
        json={"name": "Tenant2"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.get(
        "/v1/policies/",
        headers={
            "accept": "text/turtle",
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    g = Graph()
    g.parse(data=response.text)
    assert len(g) == 25

    response = client.get(
        "/v1/policies/",
        headers={
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"})

    response = response.json()
    for p in response:
        if p["access_to"] == "test":
            policy_id = p["id"]

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "accept": "text/turtle",
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    g = Graph()
    g.parse(data=response.text)
    for subj, pred, obj in g:
        if URIRef("http://www.w3.org/ns/auth/acl#accessTo") == pred:
            assert URIRef(
                "https://tenant1.orion.url/v2/entities/test") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#agentClass") == pred:
            assert URIRef("acl:agent:Gina@mail.com") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#mode") == pred:
            assert URIRef("acl:Read") == obj

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

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "accept": "text/turtle",
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    g = Graph()
    g.parse(data=response.text)
    for subj, pred, obj in g:
        if URIRef("http://www.w3.org/ns/auth/acl#accessTo") == pred:
            assert URIRef(
                "https://tenant1.orion.url/v2/entities/resource") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#agentClass") == pred:
            assert URIRef("acl:agent:test") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#mode") == pred:
            assert URIRef("acl:Read") == obj

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"},
        json={
            "access_to": "test",
            "resource_type": "subscription",
            "mode": ["acl:Write"],
            "agent": ["acl:agentGroup:Foobar"]})
    assert response.status_code == 201
    policy_id = response.headers["policy-id"]

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "accept": "text/turtle",
            "fiware-service": "Tenant1",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    g = Graph()
    g.parse(data=response.text)
    for subj, pred, obj in g:
        if URIRef("http://www.w3.org/ns/auth/acl#accessTo") == pred:
            assert URIRef(
                "https://tenant1.orion.url/v2/subscriptions/test") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#agentClass") == pred:
            assert URIRef("acl:agentGroup:Foobar") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#mode") == pred:
            assert URIRef("acl:Write") == obj

    response = client.post(
        "/v1/policies/",
        headers={
            "fiware-service": "Tenant2",
            "fiware-servicepath": "/"},
        json={
            "access_to": "test",
            "resource_type": "subscription",
            "mode": ["acl:Write"],
            "agent": ["acl:agentGroup:Foobar"]})
    assert response.status_code == 201
    policy_id = response.headers["policy-id"]

    response = client.get(
        "/v1/policies/" + policy_id,
        headers={
            "accept": "text/turtle",
            "fiware-service": "Tenant2",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    g = Graph()
    g.parse(data=response.text)
    for subj, pred, obj in g:
        if URIRef("http://www.w3.org/ns/auth/acl#accessTo") == pred:
            assert URIRef(
                "https://default.orion.url/v2/subscriptions/test") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#agentClass") == pred:
            assert URIRef("acl:agentGroup:Foobar") == obj
        elif URIRef("http://www.w3.org/ns/auth/acl#mode") == pred:
            assert URIRef("acl:Write") == obj
