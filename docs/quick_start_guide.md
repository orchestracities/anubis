# Welcome to Anubis! Quick start in few steps

This document guides you through Anubis usage.
We will demonstrate how to protect an instance of [Orion Context Broker](https://fiware-orion.rtfd.io/)
using Anubis and OIDC provider ([Keycloak](https://www.keycloak.org/)
in our case).

Basically, you will create a policy in Anubis, and see it's effects
over the Orion Context Broker.

The scenario works as follow: Orion Context Broker is protected via the Envoy
Proxy that verify with OPA-envoy if a user can access a given resource or not.
OPA-envoy first verify that the token is valid against Keycloak,
secondly it retrieves relevant policies for the user from Anubis
and use them to apply access control to the resource.

    :::ascii
    ┌─────────────┐        ┌─────────────┐        ┌─────────────┐
    │             │        │             │        │    Orion    │
    │    Client   ├───────►│ Envoy Proxy ├───────►│   Context   │
    │             │        │             │        │    Broker   │
    └──────┬──────┘        └────┬────────┘        └─────────────┘
           │                    │   ▲
           │                    │   │
           │                    ▼   │
           │               ┌────────┴────┐        ┌─────────────┐
           │               │             │◄───────┤             │
           │               │     OPA     │        │    Anubis   │
           │               │             ├───────►│             │
           │               └────┬────────┘        └─────────────┘
           │                    │   ▲
           │                    │   │
           │                    ▼   │
           │               ┌────────┴────┐
           │               │             │
           └──────────────►│  Keycloak   │
                           │             │
                           └─────────────┘

(The schema is editable at [asciiflow](https://asciiflow.com/#/share/eJyrVspLzE1VslJySc3NV9JRykmsTC0CcqtjlCpilKwszY11YpQqgSwjCzMgqyS1ogTIiVF6NGUP8UgBCmivKSYmD0krTD8WJg4p%2F6LM%2FDwoH2GWc05mal4JPrdM2wVS6ppXll%2BpEFCUX1FJSCnQ0Pw8UGii20Weu52K8rNTi5DNGqSxg8NHKMKPpm0iViUxZk4jQuXA%2Bh1L%2FD6a3kLIephSYkz2D3BEVwFlOuaVJmUWE28SQc%2FD0jcpbhxNdzRIQijKSUDQCPROrUzOyU%2FMRjcMe4jgsBmLYhL8q1SrVAsASRwJwQ%3D%3D))

## Requirements

To run this demo you'll need to have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [curl](https://www.cyberciti.biz/faq/how-to-install-curl-command-on-a-ubuntu-linux/)
- [jq](https://stedolan.github.io/jq/download/)

## Deployment

To deploy the the architecture above, use git to clone the repository, download
the keycloak scripts used to support multi-tenancy and launch docker compose:

    :::bash
    $ git clone https://github.com/orchestracities/anubis.git
    $ cd anubis
    $ source .env
    $ cd ../keycloak
    $ wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.4/oc-custom.jar -O oc-custom.jar
    $ cd ..
    $ docker compose up -d

Verify that all services are up and running:

    :::bash
    $ docker compose ps
    NAME                                COMMAND                  SERVICE                 STATUS              PORTS
    opa-authz-ext_authz-opa-service-1   "./opa_envoy_linux_a…"   ext_authz-opa-service   running             0.0.0.0:8181->8181/tcp, 0.0.0.0:8282->8282/tcp, 0.0.0.0:9191->9191/tcp
    opa-authz-front-envoy-1             "/docker-entrypoint.…"   front-envoy             running             0.0.0.0:8000->8000/tcp, 0.0.0.0:8090->8090/tcp
    opa-authz-keycloak-1                "/opt/jboss/tools/do…"   keycloak                running             0.0.0.0:8080->8080/tcp
    opa-authz-mongo-1                   "docker-entrypoint.s…"   mongo                   running             0.0.0.0:27017->27017/tcp
    opa-authz-policy-api-1              "uvicorn main:app --…"   policy-api              running             0.0.0.0:8085->8000/tcp
    opa-authz-upstream-service-1        "/usr/bin/contextBro…"   upstream-service        running (healthy)   0.0.0.0:1026->1026/tcp

## Performing basic operations with Anubis api

1. Create a tenant in Anubis

        :::bash
        $ curl -s -i -X 'POST' \
          'http://127.0.0.1:8085/v1/tenants/' \
          -H 'accept: */*' \
          -H 'Content-Type: application/json' \
          -d '{
            "name": "Tenant1"
          }'
        HTTP/1.1 201 Created
        date: Wed, 06 Apr 2022 14:03:09 GMT
        server: uvicorn
        tenant-id: 8c42e1ee-15e7-48f3-864c-1bbfbd95dea9
        Transfer-Encoding: chunked

1. Create a policy that allows creating entities under tenant `Tenant1` and
  path `/` for any correctly authenticated user.

        :::bash
        $ curl -s -i -X 'POST' \
          'http://127.0.0.1:8085/v1/policies/' \
          -H 'accept: */*' \
          -H 'fiware-service: Tenant1' \
          -H 'fiware-servicepath: /' \
          -H 'Content-Type: application/json' \
          -d '{
            "access_to": "*",
            "resource_type": "entity",
            "mode": ["acl:Write"],
            "agent": ["acl:AuthenticatedAgent"]
          }'
        HTTP/1.1 201 Created
        date: Wed, 06 Apr 2022 15:57:18 GMT
        server: uvicorn
        policy-id: a0be6113-2339-40d7-9e85-56f93372f279
        Transfer-Encoding: chunked
  
    The field `policy-id` contains the id of the policy created,
    use it in the following request.

1. Retrieve the just created policy using WAC serilization.

        :::bash
        $ curl -s -i -X 'GET' \
          'http://127.0.0.1:8085/v1/policies/a0be6113-2339-40d7-9e85-56f93372f279' \
          -H 'fiware-service: Tenant1' \
          -H 'fiware-servicepath: /' \
          -H 'Accept: text/turtle'
        HTTP/1.1 200 OK
        date: Wed, 06 Apr 2022 16:11:19 GMT
        server: uvicorn
        content-length: 273
        content-type: text/turtle; charset=utf-8

        @prefix acl: <http://www.w3.org/ns/auth/acl#> .
        @prefix example: <http://example.org/> .

        example:a0be6113-2339-40d7-9e85-56f93372f279 a acl:Authorization ;
            acl:accessTo <http://example.org/*> ;
            acl:agentClass <acl:AuthenticatedAgent> ;
            acl:mode <acl:Write> .

1. Retrieve the just created policy using rego serilization.

        :::bash
        $ curl -s -i -X 'GET' \
          'http://127.0.0.1:8085/v1/policies/a0be6113-2339-40d7-9e85-56f93372f279' \
          -H 'fiware-service: Tenant1' \
          -H 'fiware-servicepath: /' \
          -H 'Accept: text/rego'
        HTTP/1.1 200 OK
        date: Wed, 06 Apr 2022 16:13:05 GMT
        server: uvicorn
        content-length: 206
        content-type: application/json
        {
          "user_permissions": {},
          "group_permissions": {},
          "role_permissions": {
              "AuthenticatedAgent": [
                  {
                      "action": "acl:Write",
                      "resource": "*",
                      "resource_type": "entity",
                      "service_path": "/",
                      "tenant": "Tenant1"
                  }
              ]
          }
        }

1. Retrieve the just created policy using the default api format.

        :::bash
        $ curl -s -i -X 'GET' \
          'http://127.0.0.1:8085/v1/policies/a0be6113-2339-40d7-9e85-56f93372f279' \
          -H 'fiware-service: Tenant1' \
          -H 'fiware-servicepath: /'
        HTTP/1.1 200 OK
        date: Wed, 06 Apr 2022 16:13:05 GMT
        server: uvicorn
        content-length: 206
        content-type: application/json
        {
            "access_to": "*",
            "resource_type": "entity",
            "mode": [
                "acl:Write"
            ],
            "agent": [
                "acl:AuthenticatedAgent"
            ],
            "id": "a0be6113-2339-40d7-9e85-56f93372f279"
        }

## Testing the policy

1. Check if without authorization you can create an entity.

        :::bash
        $ curl -s -i -X POST 'http://localhost:8000/v2/entities' \
        -H 'Content-Type: application/json' \
        -H 'fiware-Service: Tenant1' \
        -H 'fiware-ServicePath: /' \
        -d '{
              "id": "urn:ngsi-ld:AirQualityObserved:demo",
              "type": "AirQualityObserved",
              "temperature": {
                "type": "Number",
                "value": 12.2,
                "metadata": {}
              }
            }'
        HTTP/1.1 403 Forbidden
        date: Wed, 06 Apr 2022 16:28:56 GMT
        server: envoy
        content-length: 0

1. Obtain a valid `access_token` from keycloak

        :::bash
        $ export token=`curl -s -d "client_id=ngsi&grant_type=password&username=admin&password=admin" -X POST --header "Host: keycloak:8080" 'http://localhost:8080/auth/realms/default/protocol/openid-connect/token' | \
        jq -j '.access_token'`

1. Use the token to create an entity

        :::bash
        $ curl -s -i -X POST 'http://localhost:8000/v2/entities' \
          -H 'Content: application/json' \
          -H 'fiware-Service: Tenant1' \
          -H 'fiware-ServicePath: /' \
          -H 'Content-Type: application/json' \
          -H "Authorization: Bearer $token" \
          -d '{
            "id": "urn:ngsi-ld:AirQualityObserved:demo",
            "type": "AirQualityObserved",
            "temperature": {
              "type": "Number",
              "value": 12.2,
              "metadata": {}
            }
          }'
        HTTP/1.1 201 Created
        content-length: 0
        location: /v2/entities/urn:ngsi-ld:AirQualityObserved:demo?type=AirQualityObserved
        fiware-correlator: d6a2a606-b5e0-11ec-b731-0242c0a82007
        date: Wed, 06 Apr 2022 19:36:22 GMT
        x-envoy-upstream-service-time: 107
        link: <http://policy-api:8000/v1/policies/?resource=*&&type=entity>; rel="acl"
        server: envoy

    Notice that the response header contains a link to retrieve
    the policies specific to the created entity: `http://policy-api:8000/v1/policies/?resource=*&type=entity`

1. Check the decision log in the opa service.

        :::bash
        $ docker compose logs -f
        opa-authz-ext_authz-opa-service-1  | {
        opa-authz-ext_authz-opa-service-1  |   "decision_id": "f24b02c6-ca09-4c05-8be9-65d9b1586883",
        opa-authz-ext_authz-opa-service-1  |   "input": {
        opa-authz-ext_authz-opa-service-1  |     "attributes": {
        opa-authz-ext_authz-opa-service-1  |       "destination": {
        opa-authz-ext_authz-opa-service-1  |         "address": {
        opa-authz-ext_authz-opa-service-1  |           "socketAddress": {
        opa-authz-ext_authz-opa-service-1  |             "address": "192.168.32.4",
        opa-authz-ext_authz-opa-service-1  |             "portValue": 8000
        opa-authz-ext_authz-opa-service-1  |           }
        opa-authz-ext_authz-opa-service-1  |         }
        opa-authz-ext_authz-opa-service-1  |       },
        opa-authz-ext_authz-opa-service-1  |       "metadataContext": {},
        opa-authz-ext_authz-opa-service-1  |       "request": {
        opa-authz-ext_authz-opa-service-1  |         "http": {
        opa-authz-ext_authz-opa-service-1  |           "body": "{\n      \"id\": \"urn:ngsi-ld:AirQualityObserved:demo\",\n      \"type\": \"AirQualityObserved\",\n      \"temperature\": {\n        \"type\": \"Number\",\n        \"value\": 12.2,\n        \"metadata\": {}\n      }\n    }",
        opa-authz-ext_authz-opa-service-1  |           "headers": {
        opa-authz-ext_authz-opa-service-1  |             ":authority": "localhost:8000",
        opa-authz-ext_authz-opa-service-1  |             ":method": "POST",
        opa-authz-ext_authz-opa-service-1  |             ":path": "/v2/entities",
        opa-authz-ext_authz-opa-service-1  |             ":scheme": "http",
        opa-authz-ext_authz-opa-service-1  |             "accept": "*/*",
        opa-authz-ext_authz-opa-service-1  |             "authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NDkyNzM4MzMsImlhdCI6MTY0OTI3Mzc3MywianRpIjoiODAyZjA0ZTEtYjUyNy00MDc5LTliMTEtNzJiZTdmNWRkY2JmIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvYXV0aC9yZWFsbXMvbWFzdGVyIiwic3ViIjoiNWM2N2IyNTEtNmY2My00NmYzLWIzYjAtMDg1ZTFmNzA0MGIyIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiY2xpZW50MSIsInNlc3Npb25fc3RhdGUiOiJmMDJkNGI2OC00NmZkLTQzYTctYjEzNy1hMGUyMDk3ODAyZDMiLCJhY3IiOiIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiZjAyZDRiNjgtNDZmZC00M2E3LWIxMzctYTBlMjA5NzgwMmQzIiwidGVuYW50cyI6W3sibmFtZSI6IlRlbmFudDEiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAxIiwiaWQiOiI1NzM2OTIwOS1hZTVjLTQ5YzEtYmFjNy04MmMxNmMzMDI5YmYiLCJjbGllbnRSb2xlcyI6WyJyb2xlMSJdfV0sImlkIjoiYjY5MWYxNWQtZDQ3NS00YzlkLTk3ZjctZWU4ZWMxOGFlMjYyIn0seyJuYW1lIjoiVGVuYW50MiIsImdyb3VwcyI6W3sicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJHcm91cDIiLCJpZCI6IjliMmMyYzNlLWUzY2QtNDc1OC05ZTE0LWIwMDVmZWVmMDZmMSIsImNsaWVudFJvbGVzIjpbInJvbGUyIl19XSwiaWQiOiJhNjY2MmUzZi0wMzI4LTQzZDEtYjVjZi0yNWYzMjA5YzU3ZTgifV0sImZpd2FyZS1zZXJ2aWNlcyI6eyJUZW5hbnQxIjpbIi9TZXJ2aWNlUGF0aDEiXSwiVGVuYW50MiI6WyIvU2VydmljZVBhdGgyIl19LCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJlbWFpbCI6ImFkbWluQG1haWwuY29tIn0.SIghLtmI7mzE6wfP1VdfjYVwl5me88I9_0KrLSOtmICtSZ5msKPLivmM4gY30cEyYPRii-XiWeLVZEwQq7FJYBP1kLTMjIDXUiRwjfNIfwKkCymxYjkgf_0jvPCqXuS9CabcUmBizXVtufvqOGsEZ94TmFui8xxXcIaqxXtRecv0vbVr5rcnM0UVa0z4p-jOQAoPtzBtDD_IkAvuYBoeqCCtAvFY4wSV3qYIj5GUD87gmO8Q0ebUcP-ZaWJokhchyAPffZ41oErCXXd9tS0e155Fa2bCnP-RQMMSDes_G_ZiRjaBinjmemgrfMNhJJzcIyevEgwCLsTBGEscZh1ztw",
        opa-authz-ext_authz-opa-service-1  |             "content": "application/json",
        opa-authz-ext_authz-opa-service-1  |             "content-length": "197",
        opa-authz-ext_authz-opa-service-1  |             "content-type": "application/json",
        opa-authz-ext_authz-opa-service-1  |             "fiware-service": "Tenant1",
        opa-authz-ext_authz-opa-service-1  |             "fiware-servicepath": "/",
        opa-authz-ext_authz-opa-service-1  |             "user-agent": "curl/7.77.0",
        opa-authz-ext_authz-opa-service-1  |             "x-envoy-auth-partial-body": "false",
        opa-authz-ext_authz-opa-service-1  |             "x-forwarded-proto": "http",
        opa-authz-ext_authz-opa-service-1  |             "x-request-id": "bb8eeff8-7331-48df-af21-dbbc1f0e6859"
        opa-authz-ext_authz-opa-service-1  |           },
        opa-authz-ext_authz-opa-service-1  |           "host": "localhost:8000",
        opa-authz-ext_authz-opa-service-1  |           "id": "17581640675563979345",
        opa-authz-ext_authz-opa-service-1  |           "method": "POST",
        opa-authz-ext_authz-opa-service-1  |           "path": "/v2/entities",
        opa-authz-ext_authz-opa-service-1  |           "protocol": "HTTP/1.1",
        opa-authz-ext_authz-opa-service-1  |           "scheme": "http",
        opa-authz-ext_authz-opa-service-1  |           "size": "197"
        opa-authz-ext_authz-opa-service-1  |         },
        opa-authz-ext_authz-opa-service-1  |         "time": "2022-04-06T19:36:21.791818Z"
        opa-authz-ext_authz-opa-service-1  |       },
        opa-authz-ext_authz-opa-service-1  |       "source": {
        opa-authz-ext_authz-opa-service-1  |         "address": {
        opa-authz-ext_authz-opa-service-1  |           "socketAddress": {
        opa-authz-ext_authz-opa-service-1  |             "address": "192.168.32.1",
        opa-authz-ext_authz-opa-service-1  |             "portValue": 56908
        opa-authz-ext_authz-opa-service-1  |           }
        opa-authz-ext_authz-opa-service-1  |         }
        opa-authz-ext_authz-opa-service-1  |       }
        opa-authz-ext_authz-opa-service-1  |     },
        opa-authz-ext_authz-opa-service-1  |     "parsed_body": {
        opa-authz-ext_authz-opa-service-1  |       "id": "urn:ngsi-ld:AirQualityObserved:demo",
        opa-authz-ext_authz-opa-service-1  |       "temperature": {
        opa-authz-ext_authz-opa-service-1  |         "metadata": {},
        opa-authz-ext_authz-opa-service-1  |         "type": "Number",
        opa-authz-ext_authz-opa-service-1  |         "value": 12.2
        opa-authz-ext_authz-opa-service-1  |       },
        opa-authz-ext_authz-opa-service-1  |       "type": "AirQualityObserved"
        opa-authz-ext_authz-opa-service-1  |     },
        opa-authz-ext_authz-opa-service-1  |     "parsed_path": [
        opa-authz-ext_authz-opa-service-1  |       "v2",
        opa-authz-ext_authz-opa-service-1  |       "entities"
        opa-authz-ext_authz-opa-service-1  |     ],
        opa-authz-ext_authz-opa-service-1  |     "parsed_query": {},
        opa-authz-ext_authz-opa-service-1  |     "truncated_body": false,
        opa-authz-ext_authz-opa-service-1  |     "version": {
        opa-authz-ext_authz-opa-service-1  |       "encoding": "protojson",
        opa-authz-ext_authz-opa-service-1  |       "ext_authz": "v3"
        opa-authz-ext_authz-opa-service-1  |     }
        opa-authz-ext_authz-opa-service-1  |   },
        opa-authz-ext_authz-opa-service-1  |   "labels": {
        opa-authz-ext_authz-opa-service-1  |     "id": "3b87bc86-6346-42a6-b29c-273002ea0284",
        opa-authz-ext_authz-opa-service-1  |     "version": "0.38.1-envoy-3"
        opa-authz-ext_authz-opa-service-1  |   },
        opa-authz-ext_authz-opa-service-1  |   "level": "info",
        opa-authz-ext_authz-opa-service-1  |   "metrics": {
        opa-authz-ext_authz-opa-service-1  |     "timer_rego_builtin_http_send_ns": 118889000,
        opa-authz-ext_authz-opa-service-1  |     "timer_rego_query_eval_ns": 143613666,
        opa-authz-ext_authz-opa-service-1  |     "timer_server_handler_ns": 166592875
        opa-authz-ext_authz-opa-service-1  |   },
        opa-authz-ext_authz-opa-service-1  |   "msg": "Decision Log",
        opa-authz-ext_authz-opa-service-1  |   "path": "envoy/authz/allow",
        opa-authz-ext_authz-opa-service-1  |   "result": {
        opa-authz-ext_authz-opa-service-1  |     "allowed": true,
        opa-authz-ext_authz-opa-service-1  |     "response_headers_to_add": {
        opa-authz-ext_authz-opa-service-1  |       "Link": "\u003chttp://policy-api:8000/v1/policies/?resource=*\u0026\u0026type=entity\u003e; rel=\"acl\""
        opa-authz-ext_authz-opa-service-1  |     }
        opa-authz-ext_authz-opa-service-1  |   },
        opa-authz-ext_authz-opa-service-1  |   "time": "2022-04-06T19:36:21Z",
        opa-authz-ext_authz-opa-service-1  |   "timestamp": "2022-04-06T19:36:21.973122844Z",
        opa-authz-ext_authz-opa-service-1  |   "type": "openpolicyagent.org/decision_logs"
        opa-authz-ext_authz-opa-service-1  | }
