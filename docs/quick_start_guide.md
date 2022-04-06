# Welcome to Anubis! Quick start in few steps

This document guides you through Anubis usage.
We will demonstrate how to protect an instance of [Orion Context Broker](https://fiware-orion.rtfd.io/)
using Anubis and ODIC provider ([Keycloak](https://www.keycloak.org/)
in our case).

Basically, you will create a policy in Anubis, and see it's effects
over the Orion Context Broker.

The scenario works as follow: Orion Context Broker is protected via the Envoy
Proxy that verify with OPA-envoy if a user can access a given resource or not.
OPA-envoy first verify that the token is valid against Keycloak,
secondly it retrieves relevant policies for the user from Anubis
and use them to apply access control to the resource.

```ascii
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
```

(The schema is editable at [asciiflow](https://asciiflow.com/#/share/eJyrVspLzE1VslJySc3NV9JRykmsTC0CcqtjlCpilKwszY11YpQqgSwjCzMgqyS1ogTIiVF6NGUP8UgBCmivKSYmD0krTD8WJg4p%2F6LM%2FDwoH2GWc05mal4JPrdM2wVS6ppXll%2BpEFCUX1FJSCnQ0Pw8UGii20Weu52K8rNTi5DNGqSxg8NHKMKPpm0iViUxZk4jQuXA%2Bh1L%2FD6a3kLIephSYkz2D3BEVwFlOuaVJmUWE28SQc%2FD0jcpbhxNdzRIQijKSUDQCPROrUzOyU%2FMRjcMe4jgsBmLYhL8q1SrVAsASRwJwQ%3D%3D)))

## Requirements

To run this demo you'll need to have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [curl](https://www.cyberciti.biz/faq/how-to-install-curl-command-on-a-ubuntu-linux/)
- [jq](https://stedolan.github.io/jq/download/)

## Deployment

To deploy the the architecture above, use git to clone the repository, download
the keycloak scripts used to support multi-tenancy and launch docker compose:

```bash
$ git clone https://github.com/orchestracities/anubis.git
$ cd anubis
$ source .env
$ cd ../keycloak
$ wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.4/oc-custom.jar -O oc-custom.jar
$ cd ..
$ docker compose up -d
```

Verify that all services are up and running (it ):

```bash
$ docker compose ps     
NAME                                COMMAND                  SERVICE                 STATUS              PORTS
opa-authz-ext_authz-opa-service-1   "./opa_envoy_linux_a…"   ext_authz-opa-service   running             0.0.0.0:8181->8181/tcp, 0.0.0.0:8282->8282/tcp, 0.0.0.0:9191->9191/tcp
opa-authz-front-envoy-1             "/docker-entrypoint.…"   front-envoy             running             0.0.0.0:8000->8000/tcp, 0.0.0.0:8090->8090/tcp
opa-authz-keycloak-1                "/opt/jboss/tools/do…"   keycloak                running             0.0.0.0:8080->8080/tcp
opa-authz-mongo-1                   "docker-entrypoint.s…"   mongo                   running             0.0.0.0:27017->27017/tcp
opa-authz-policy-api-1              "uvicorn main:app --…"   policy-api              running             0.0.0.0:8085->8000/tcp
opa-authz-upstream-service-1        "/usr/bin/contextBro…"   upstream-service        running (healthy)   0.0.0.0:1026->1026/tcp
```

## Performing basic operations with Anubis api 

1. Create a tenant in Anubis

    ```bash
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
    ```
1. Create a policy that allows creating entities under tenant `Tenant1` and
    path `/` for any correctly authenticated user.

    ```bash
    $ curl -s -i -X 'POST' \
      'http://127.0.0.1:8085/v1/policies/' \
      -H 'accept: */*' \
      -H 'fiware_service: Tenant1' \
      -H 'fiware_service_path: /' \
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
    ```

1. Retrieve the just created policy using WAC format.

    ```bash
    $ curl -s -i -X 'GET' \
      'http://127.0.0.1:8085/v1/policies/a0be6113-2339-40d7-9e85-56f93372f279' \
      -H 'fiware_service: Tenant1' \
      -H 'fiware_service_path: /' \
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
    ```

1. Retrieve the just created policy using rego format.

    ```bash
    $ curl -s -i -X 'GET' \
      'http://127.0.0.1:8085/v1/policies/a0be6113-2339-40d7-9e85-56f93372f279' \
      -H 'fiware_service: Tenant1' \
      -H 'fiware_service_path: /' \
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
    ```

1. Retrieve the just created policy using the default api format.

    ```bash
    $ curl -s -i -X 'GET' \
      'http://127.0.0.1:8085/v1/policies/a0be6113-2339-40d7-9e85-56f93372f279' \
      -H 'fiware_service: Tenant1' \
      -H 'fiware_service_path: /'
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
    ```

## Testing the policy

1. Check if without authorization you can create an entity.

    ```bash
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
    ```

1. Obtain a valid `access_token` from keycloak

    ```bash
    $ export token=`curl -s -d "client_id=client1&grant_type=password&username=admin&password=admin" -X POST --header "Host: keycloak:8080" 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' | \
    jq -j '.access_token'`
    ```

1. Use the token to create an entity

    ```bash
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
    fiware-correlator: aa6bc548-b5d8-11ec-84e1-0242ac1c0007
    date: Wed, 06 Apr 2022 18:37:51 GMT
    x-envoy-upstream-service-time: 123
    server: envoy
    ```
