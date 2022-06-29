from fastapi.testclient import TestClient

from ..main import app
from .utils import test_db

client = TestClient(app)


def test_audit_logs(test_db):
    response = client.post(
        "/v1/tenants/",
        json={"name": "test"}
    )
    assert response.status_code == 201
    tenant_id = response.headers["tenant-id"]
    assert tenant_id

    response = client.post(
        "/v1/audit/logs",
        json=[{
            "labels": {
              "id": "9ff04373-def7-4abd-a0de-3feca846a8c9",
              "version": "0.38.1-envoy-3"
              },
            "decision_id": "f0e52296-aa2f-45e6-9f0f-af884523b8fb",
            "path": "envoy/authz/allow",
            "input": {
                "mode": "acl:Read",
                "service": "context broker",
                "resource": "*",
                "resource_type": "entity",
                "attributes": {
                    "destination": {
                        "address": {
                            "socketAddress": {
                                "address": "192.168.48.6",
                                "portValue": 8000
                            }
                        }
                    },
                    "metadataContext": {},
                    "request": {
                        "http": {
                            "headers": {
                                ":authority": "localhost:8000",
                                ":method": "GET",
                                ":path": "/v2/entities",
                                ":scheme": "http",
                                "accept": "*/*",
                                "authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NTU0Nzc5NDEsImlhdCI6MTY1NTQ3Nzg4MSwianRpIjoiYThjZDg1MTMtNmY2YS00Y2VlLWFmNTEtZjlmMjdmZWU0YmZhIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvYXV0aC9yZWFsbXMvbWFzdGVyIiwic3ViIjoiNWM2N2IyNTEtNmY2My00NmYzLWIzYjAtMDg1ZTFmNzA0MGIyIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiY2xpZW50MSIsInNlc3Npb25fc3RhdGUiOiIzYjhhZDJkMS1kNjg3LTQ4NjItOTliMi1lZmEyOGQ3NGIxNGEiLCJhY3IiOiIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiM2I4YWQyZDEtZDY4Ny00ODYyLTk5YjItZWZhMjhkNzRiMTRhIiwidGVuYW50cyI6W3sibmFtZSI6IlRlbmFudDEiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAxIiwiaWQiOiI1NzM2OTIwOS1hZTVjLTQ5YzEtYmFjNy04MmMxNmMzMDI5YmYiLCJjbGllbnRSb2xlcyI6WyJyb2xlMSJdfV0sImlkIjoiYjY5MWYxNWQtZDQ3NS00YzlkLTk3ZjctZWU4ZWMxOGFlMjYyIn0seyJuYW1lIjoiVGVuYW50MiIsImdyb3VwcyI6W3sicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJHcm91cDIiLCJpZCI6IjliMmMyYzNlLWUzY2QtNDc1OC05ZTE0LWIwMDVmZWVmMDZmMSIsImNsaWVudFJvbGVzIjpbInJvbGUyIl19XSwiaWQiOiJhNjY2MmUzZi0wMzI4LTQzZDEtYjVjZi0yNWYzMjA5YzU3ZTgifV0sImZpd2FyZS1zZXJ2aWNlcyI6eyJUZW5hbnQxIjpbIi9TZXJ2aWNlUGF0aDEiXSwiVGVuYW50MiI6WyIvU2VydmljZVBhdGgyIl19LCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJlbWFpbCI6ImFkbWluQG1haWwuY29tIn0.u2TBbnjD2V52QLiCcP8w0XUkiS7-ELrfySDAsM16NAEsSwE0U1Cm_uAVXQ6cwkbQ9Uc29oc7AY88qTXwEtI2Zb7q96ZPrhrIt3gVpXhA8Ov7MZXWBJ2vuVwx2lTylQ6xUxYnAors_lYS95bUlpkF43kuqlL9zwhxBrkaD3--l5F5d8GFk2-cyr5wPCQN7aS4dEXx9k4j72o3G-0GPXbSQXTZDhJa9SILl05nf5vpBHaqtdfcSsL6a8koipBGi5Ai1aZmcsfdkw21WtTYspPpiESZyutz9RIY_NzyKe0IuAYKqebHea48IkLXliuDSR9oJN_OOon1kYuBsFkpDmgfdA",
                                "fiware-service": "test",
                                "fiware-servicepath": "/",
                                "user-agent": "curl/7.77.0",
                                "x-forwarded-proto": "http",
                                "x-request-id": "55870d92-547c-4274-bbae-2a2e81d36d04"
                            },
                            "host": "localhost:8000",
                            "id": "15943849726142102952",
                            "method": "GET",
                            "path": "/v2/entities",
                            "protocol": "HTTP/1.1",
                            "scheme": "http"
                        },
                        "time": "2022-06-17T14:58:03.075222Z"
                    },
                    "source": {
                        "address": {
                            "socketAddress": {
                                "address": "192.168.48.1",
                                "portValue": 61140
                            }
                        }
                    }
                },
                "parsed_body": None,
                "parsed_path": [
                    "v2",
                    "entities"
                ],
                "parsed_query": {},
                "truncated_body": False,
                "version": {
                    "encoding": "protojson",
                    "ext_authz": "v3"
                }
            },
            "result": {
                "allowed": True,
                "response_headers_to_add": {
                    "Link": "<http://policy-api:8000/v1/policies/?resource=*&&type=entity>; rel=\"acl\""
                }
            },
            "timestamp": "2022-06-17T14:58:03.143902342Z",
            "metrics": {
                "counter_rego_builtin_http_send_interquery_cache_hits": 2,
                "timer_rego_builtin_http_send_ns": 48701126,
                "timer_rego_query_eval_ns": 65339708,
                "timer_server_handler_ns": 66836209
            }
        }]
    )
    assert response.status_code == 200

    response = client.get(
        "/v1/audit/logs",
        headers={
            "fiware-service": "test",
            "fiware-servicepath": "/"})
    assert response.status_code == 200
    body = response.json()
    assert len(body) == 1
