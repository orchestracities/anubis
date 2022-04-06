# Access Control Policy Management

This API provides functionalities to manage Role Base Access Control policies.
The policy management part is complemented by Tenant and Service management
as supported by FIWARE APIs.

While policies are expressed in a generic way, and as such this means
that policies works also for other APIs beyond FIWARE, FIWARE
introduced a specific way to support multi-tenancy, and this API
complies with FIWARE multi-tenancy model.

A tenant, also named as `Fiware-Service`, is further segmented into
`ServicePath`s, i.e. hierarchical scoping of the resources part
of a given tenant. For a more detailed discussion, you can
read the related discussion in FIWARE Orion Context Broker
[documentation](https://fiware-orion.readthedocs.io/en/master/user/service_path/index.html).

This API in short provides a PAP (Policy Administration Point),
it does not provide PEP or PDP, it only stores the policies.
PEP is provided by [Envoy](https://www.envoyproxy.io) and PDP is provided by
[OPA](https://www.openpolicyagent.org/).

Currently the policy models is based on
[W3C web access control spec](https://github.com/solid/web-access-control-spec).

Obviously, compared to other languages, expressive power may be quite limited.
This may be extended in the future with some custom functionalities (for
example to support
[ABAC](https://en.wikipedia.org/wiki/Attribute-based_access_control)).
This feature could leverage a json query languages such as:

* [ObjectPath](http://objectpath.org/)
* [jsonpath](https://pypi.org/project/jsonpath/)
* [yaql](https://yaql.readthedocs.io/en/latest/readme.html)
* [pyjq](https://pypi.org/project/pyjq/)
* [JMESPath](https://github.com/jmespath/jmespath.py)

## Short overview

The API is composed by two main paths:

* `/v1/tenants` supporting definition of tenants (FIWARE Services) and paths
    (FIWARE Service Paths).
    *NOTE:* FIWARE Service Paths may be gone with NGSI-LD.

* `/v1/policies` supporting definition of web access policies (linked to tenants
    and service paths). Under the hood, this path also creates and stores
    information linked to policies:

  * Agents (i.e. user or user groups definitions);

## Current status

Supported features:

* The codebase allows the creation of tenants (related service paths) and
  policies.

* The codebase allows to generate a base translation of policies in `acl`
  and `rego` compatible format (i.e. a data structure that is used as input
  data for policy evaluation by OPA).

## Next steps

The following activities need to be implemented as next steps:

* Push data for policy evaluation into OPA when a policy is updated
  (rather that OPA pulling them as it happens now). This client could help:
  [https://pypi.org/project/OPA-python-client/](https://pypi.org/project/OPA-python-client/)

* Investigate if we need to provide to OPA access to knowledge available in the
  IDM provider or define token standard information to be included into the
  token (which may become quite big so better to think about that).

* Support `any` service_path policies (e.g. `/*` or `/#`). *NOTE*:
  this may be more complex in `acl` than in `rego`, since as a matter
  of fact, notion of service and tenant is hidden to acl itself.
  While tenant can characterised as `acl:Group`,
  service_path is a dimension of the resource.

* Support `any` resource policies (e.g. `/v2/*` ),
  this in acl may look like:
  `acl:accessToClass [ acl:regex "https://bblfish.solid.example/.*" ];`

* Decide wether using only acl defined access modes, e.g. `acl:Write`,
    `acl:Read`, or allowing also custom ones, e.g. `entity:read`.

* Support `PATCH` for the policy management API (may be complicate for the
  service paths, in case you change the `path` since this affects all
  `children` path).

* Allow configuration of db, OPA endpoint, ect.

* Handle ownership.

* Support disabling multi-tenancy.

## Requirements

* Python 3.9
* pipenv
* A database supported by sqlalchemy

## Starts the API (dev mode)

```bash
$ pipenv install --dev
$ pipenv shell
$ cd src
$ uvicorn main:app --reload
```

## Test the API

```bash
$ pytest -rP
```

## API documentation

Once the API is running, you can check it at: `http://127.0.0.1:8000/docs`

## API testing

Here are few curl calls that exemplify how the API works:

1. Let's create a tenant:

    ```bash
    $curl -i -X 'POST' \
      'http://127.0.0.1:8000/v1/tenants/' \
      -H 'accept: */*' \
      -H 'Content-Type: application/json' \
      -d '{
      "name": "EKZ"
    }'

    HTTP/1.1 201 Created
    date: Sat, 28 Aug 2021 11:50:51 GMT
    server: uvicorn
    tenant-id: c8a056f9-4c8a-4961-a5f5-2bd61346c4f6
    Transfer-Encoding: chunked
    ```

    As you can see the response headers include the id of the newly created
    tenant.

1. Let's get the tenant info:

    ```bash
    $curl -X 'GET' \
    'http://127.0.0.1:8000/v1/tenants/4385a69f-6d3d-49ed-b342-848f30297a05' \
    -H 'accept: application/json'

    {
      "name":"EKZ",
      "id":"4385a69f-6d3d-49ed-b342-848f30297a05",
      "service_paths":[
        {
          "path":"/",
          "id":"02f071c7-82b4-41ab-895e-2bd28e7386a9",
          "tenant_id":"4385a69f-6d3d-49ed-b342-848f30297a05",
          "parent_id":null,
          "scope":null,
          "children":[]
        }
      ]
    }
    ```

    A default service path `/` is always created.

1. Let's create a policy for this service path and tenant.
    We define the permission type using `acl` modes,
    in this case we authorise reading the resource `/v2/entities/urn:myentity`,
    in tenant `EKZ`, service path `/`

    ```bash
    $curl -i -X 'POST' \
    'http://127.0.0.1:8000/v1/policies/' \
    -H 'accept: */*' \
    -H 'fiware-service: EKZ' \
    -H 'fiware-servicepath: /' \
    -H 'Content-Type: application/json' \
    -d '{
    "access_to": "urn:myentity",
    "resource_type": "entity",
    "mode": ["acl:Read"],
    "agent": ["acl:AuthenticatedAgent"]
    }'

    HTTP/1.1 201 Created
    date: Sat, 28 Aug 2021 11:59:43 GMT
    server: uvicorn
    policy-id: 5c3ac3b2-ad98-4358-8525-a3f7947170af
    Transfer-Encoding: chunked
    ```

    Also in this case the id of the newly create policy is returned.

1. Let's retrieve the policy:

    ```bash
    $curl -i -X 'GET' \
    'http://127.0.0.1:8000/v1/policies/5c3ac3b2-ad98-4358-8525-a3f7947170af?skip=0&limit=100' \
    -H 'accept: application/json' \
    -H 'fiware-service: EKZ' \
    -H 'fiware-servicepath: /'

    HTTP/1.1 200 OK
    date: Sat, 28 Aug 2021 12:01:40 GMT
    server: uvicorn
    content-length: 140
    content-type: application/json

    {
      "access_to":"urn:myentity",
      "resource_type":"entity",
      "mode":["acl:Read"],
      "agent":["acl:AuthenticatedAgent"],
      "id":"5c3ac3b2-ad98-4358-8525-a3f7947170af"
    }
    ```

1. Let's retrieve the policy as acl:

    ```bash
    $curl -i -X 'GET' \
    'http://127.0.0.1:8000/v1/policies/5c3ac3b2-ad98-4358-8525-a3f7947170af?skip=0&limit=100' \
    -H 'accept: text/turtle' \
    -H 'fiware-service: EKZ' \
    -H 'fiware-servicepath: /'

    HTTP/1.1 200 OK
    date: Sat, 28 Aug 2021 12:02:52 GMT
    server: uvicorn
    content-length: 229
    content-type: text/turtle; charset=utf-8

    @prefix acl: <http://www.w3.org/ns/auth/acl#> .

    <http:/www.w3.org/ns/auth/5c3ac3b2-ad98-4358-8525-a3f7947170af> acl:accessTo </v2/entities/urn:myentity> ;
        acl:agentClass <acl:AuthenticatedAgent> ;
        acl:mode <acl:Read> .
    ```

1. Let's retrieve the policy as rego data:

    ```bash
    $curl -i -X 'GET' \
    'http://127.0.0.1:8000/v1/policies/5c3ac3b2-ad98-4358-8525-a3f7947170af?skip=0&limit=100' \
    -H 'accept: text/rego' \
    -H 'fiware-service: EKZ' \
    -H 'fiware-servicepath: /'

    HTTP/1.1 200 OK
    date: Sat, 28 Aug 2021 12:03:57 GMT
    server: uvicorn
    content-length: 1289
    content-type: text/rego; charset=utf-8

    {
    "role_permissions": {
        "AuthenticatedAgent": [
          {
            "action": "acl:Read",
            "resource": "urn:myentity",
            "resource_type": "entity",
            "tenant": "EKZ",
            "service_path": "/"
          }
        ]
      }
    }
    ```
