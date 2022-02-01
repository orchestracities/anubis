# OPA-authz

Welcome to OPA-authz (we are looking for a better name, if you have ideas
please share :-) )!

## What is the project about?

This project explores the development of a flexible Policy Enforcement Proxy
that makes easier to reuse security policies across different services,
assuming the policies entail the same resource.
In short we are dealing with policy portability :) What do you mean by policy
portability?

Let's think of a user that register some data in platform A.
To control who can his data he develops a set of policies.
If he move the data to platform B, most probably he will have to define again
the control access policies for that data also in platform B.

Our aim is to avoid that :) or at least simplify this as much as possible
for the data owner.

## Why this project?

Data portability often focuses on the mechanisms to exchange data and the
formalisation of dat representation: the accent is rarely put
on the portability of security & privacy data policies.
Enabling security and privacy data policy portability is clearly
a step forward in enabling data sovereignty across different services.

This project aims at enabling data sovereignty by introducing data privacy and
security policy portability and prototyping distributed data privacy
and security policy management, thus contributing to increase
trust toward data sharing APIs and platforms.

Approaches as the one proposed, increasing control by owners over their data and
portability of data assets, are key to boost the establishment of
trusted data spaces.

The project is looking into

- Open standardized security & privacy data policies vocabulary.
- Linking an existing user profiling vocabulary to the security & privacy data
    policies vocabulary as a way to increase portability of policies and their
    compatibility to existing standards.
- A middleware supporting decentralised control and audit of security & privacy
    data policies by data owners (in the context of RESTful APIs).
- Translation from the security & privacy data policies vocabulary to other
    policy languages or APIs that are actually used for PEP.

## Status

The project is currently a Proof of Concept (POC) that explores how policy
expressed using [Web Access control](https://solid.github.io/web-access-control-spec/)
can be enforced via [OPA](https://www.openpolicyagent.org/) in the context of
NGSIv2 APIs.

## Architecture

In our scenario, a client request for a resource to an API, and based on the
defined policies, the client is able or not to access the resource.
The figure below shows the current architecture.

```ascii
                           ┌─────────────┐
                           │     API     │
                           │  Specific   │
                           │    Rules    │
                           └─────────────┘
                                  ▲
                                2 │
                                  │
    ┌─────────────┐        ┌──────┴──────┐        ┌─────────────┐
    │             │   1    │   Policy    │   4    │             │
    │    Client   ├───────►│ Enforcement ├───────►│     API     │
    │             │        │    Point    │        │             │
    └─────────────┘        └──────┬──────┘        └─────────────┘
                                  │
                                3 │
                                  ▼
                           ┌─────────────┐
                           │    Policy   │
                           │  Management │
                           │     API     │
                           └─────────────┘

```

[//]: # (editable at [asciiflow](https://asciiflow.com/#/share/eJyrVspLzE1VssorzcnRUcpJrEwtUrJSqo5RqohRsrI0N9aJUaoEsozMLYCsktSKEiAnRkkBO3g0ZQ%2FxKCYmD7cxYNoxwBPGJ6Q4uCA1OTMtM5koxQpBpTmpxcSYTA3fwEybtomwGmLMAashyW1keYjcUEDSCtMPJA0RzID8nMzkSgRfAY2J6ksQxzknMzWvBJ9bpu0CKXXNS8svSk7NBSkmoBQEUJMXdncjMQPyM8GOIM7dgzR2cCYrJNdTQc002mcrLImJqiUKCp9avlGqVaoFAKtNRnk%3D))

1. A client requests for a resource via the Policy Enforcement Point (PEP) -
    implemented using a authz envoy
[authz filter](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/ext_authz).
1. The PEP evaluates a set of rules that apply the abstract policies to the
    specific API to be protected
1. In combination with the policies stored in the Policy Management API;
1. If the evaluation of the policies return 'allowed', then the request is
    forwarded to the API.

## Policy management

The POCs currently supports only Role Based Access Control policies. Policies
are stored in the [policy management api](auth-management-api), that supports
the translation to WAC and to a data input format supported by
[OPA](https://www.openpolicyagent.org/), the engine that performs
the policy evaluation.

At the time being, the API specific rules have been developed
specifically for the [NGSIv2 Context Broker](https://fiware-orion.readthedocs.io/en/master/)
and JWT-based authentication. You can see these rule in this
[rego file](config/opa-service/policy.rego).

### Policy format

The policy internal data format is inspired by
[Web Access control](https://solid.github.io/web-access-control-spec/).
See [policy management api](auth-management-api) for details.

In general, a policy is defined by:

- *actor*: The user, group or role, that is linked to the policy
- *action*: The action allowed on this resource (e.g. acl:Read for GET requests)
- *resource*: The urn of the resource being targeted (e.g. urn:entity:x)
- *resource_type*: The type of the resource (e.g. entity, entity_type,
  subscription,  device, ...)
  
Additionally, in relation to FIWARE APIs, a policy may include also:

- *tenant*: The tenant this permission falls under
- *service_path*: The service path this permission falls under

For the usage with OPA, policies are translated into OPA data format.
For example, user based access control policies will be translated as:

  ```json
  {
  "user_permissions": {
      "1c4f9f82-e5a7-4b32-84ea-a1774531f1d2": [
        {
          "action": "acl:Read",
          "resource": "*",
          "resource_type": "entity",
          "tenant": "Tenant",
          "service_path": "/"
        },
        {
          "action": "acl:Write",
          "resource": "foo",
          "resource_type": "entity",
          "tenant": "Tenant",
          "service_path": "/"
        }
      ]
    }
  }
  ```

See the [test file](config/opa-service/policy_test.rego) for more examples.

To apply the policy to a specific API, allowed modes (according to WAC spec currently),
are mapped to a specific HTTP method, e.g.:

  ```javascript
  scope_method := {"acl:Read": ["GET"], "acl:Write": ["POST"], "acl:Control": ["PUT", "DELETE"]}
  ```

Specific rules are defined based on the spec of the API to protect, e.g.:

  ```javascript
  # Checks if the entity in the policy matches the path
  path_matches_policy(resource, resource_type, path) {
    resource_type = "entity"
    current_path := split(path, "/")
    current_path[1] == "v2"
    current_path[2] == "entities"
    current_path[3] == resource
  }

  # User permissions
  user_permitted {
    is_token_valid
    entry := data.user_permissions[token.payload.sub][_]
    scope_method[entry.action][_] == request.action
    path_matches_policy(entry.resource, entry.resource_type, request.resource)
    entry.tenant == request.tenant
    entry.service_path == request.service_path
  }
  ```

In this case, the `path_matches_policy` check if a the incoming request has a
given format, while `user_permitted` checks if according to the user based
access policies, the request is allowed.

## Authentication

The authentication per se is not covered by the PEP, the assumption is that
the client authenticates before issuing and obtains a valid JWT token.

Currently the PEP only verifies that the token is valid:

  ```javascript
  is_token_valid {
    now := time.now_ns() / 1000000000
    token.payload.nbf <= now
  }
  ```

Of course, more complex validations are possible.
See [OPA Docs](https://www.openpolicyagent.org/docs/latest/oauth-oidc/)
for additional examples.

Currently, the token, when decoded, should contain:

- The ID of the user making the request
- The groups the user belongs to and their respective tenants
- The roles the user has under their respective tenants

## Demo

To run the demo:

  ```bash
  $ source .env
  $ docker-compose up -d
  $ sh test_rego.sh
  ```

## Status and Roadmap

The current PoC provides already a quite complete validation of the
overall goals. For additional planned features you can
check either the text below, or the pending [issues](issues).

- [ ] Design an API that allow to record policies for tenant.
  - [x] Store a policy as a tuple: *who* can access *which* resource to do
    *what* (eventually in future also when and how).
    A prototype is available, see [auth-management-api](auth-management-api).
  - [x] Allow to create and manage "service_paths" for tenants.
    A prototype is available, see [auth-management-api](auth-management-api).
  - [ ] Have way to define who can define policy for which resource
    (it could be based on the same approach)
  - [ ] Allows to test policies calling OPA validator
- [ ] Design a translator that
  - [x] Coverts the abstract policy who / whom / what
  into a OPA compatible format.
  A prototype is available, see [auth-management-api](auth-management-api).
  - [x] Define a set of rules that enforce policies on a specific API.
     A prototype is available, see [policy.rego](config/opa-service/policy.rego).
  - [ ] Store policies in OPA, instead of retrieve them.
  - [ ] Record additional data in the OPA data API as needed
    (may not be required)

To adhere to [W3C web access control spec](https://github.com/solid/web-access-control-spec)
the API management prototype available at [auth-management-api](auth-management-api)
uses acl defined access modes, e.g. `acl:Write`, `acl:Read`, which are different
from the ones in [config/opa-service/policy.rego](config/opa-service/policy.rego)
example (e.g. `entity:read`). In many use cases, this modes are not enough, and
we may need to define an extension of `acl` with modes needed in our APIs.

The [auth-management-api](auth-management-api) is a prototype, it needs some
work to be more configurable, e.g. in term of db.
