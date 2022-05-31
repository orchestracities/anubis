# Anubis

[![FIWARE Security](https://nexus.lab.fiware.org/repository/raw/public/badges/chapters/security.svg)](https://www.fiware.org/developers/catalogue/)
[![License: APACHE-2.0](https://img.shields.io/github/license/orchestracities/anubis.svg)](https://opensource.org/licenses/APACHE-2.0)
[![Docker Status](https://img.shields.io/docker/pulls/orchestracities/anubis-management-api.svg)](https://hub.docker.com/r/orchestracities/anubis-management-api)
[![Support](https://img.shields.io/badge/support-ask-yellowgreen.svg)](https://github.com/orchestracities/anubis/issues)
[![Documentation badge](https://img.shields.io/readthedocs/anubis-pep.svg)](https://anubis-pep.readthedocs.io/en/latest/)

Welcome to Anubis!

| :books: [Documentation](https://anubis-pep.readthedocs.io/en/latest/) | :whale: [Docker Hub](https://hub.docker.com/r/orchestracities/anubis-management-api) |
| ------------- | ---------------|

## What is the project about?

Anubis is a flexible Policy Enforcement solution
that makes easier to reuse security policies across different services,
assuming the policies entail the same resource.
In short we are dealing with policy portability :) What do you mean by policy
portability?

Let's think of a user that register some data in platform A.
To control who can access his data he develops a set of policies.
If he moves the data to platform B, most probably he will have to define again
the control access policies for that data also in platform B.

Anubis aims to avoid that :) or at least simplify this as much as possible
for the data owner. How? Leveraging open source solutions (e.g.
[Envoy](https://www.envoyproxy.io/),
[OPA](https://www.openpolicyagent.org/)) and reference standards
(e.g. [W3C WAC](https://solid.github.io/web-access-control-spec/),
[W3C ODRL](https://www.w3.org/TR/odrl-model/), [OAUTH2](https://oauth.net/2/)).

Of course, the support for distributed policies management may be of value
also for a single platform deployed distributedly, e.g. to synch policies
across the cloud-edge.

## Why this project?

Data portability often focuses on the mechanisms to exchange data and the
formalisation of data representation: the accent is rarely put
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

While Anubis is not subject to GDPR per se, it allows API owners to implement
effective GDPR in their solutions.

## Why did you pick Anubis as name?

[Anubis](https://en.wikipedia.org/wiki/Anubis) is an ancient Egyptian god,
that has multiple roles in the mythology of ancient Egypt. In particular,
we opted for this name, because he decides the fate of souls:
based on their weights he allows the souls to ascend to a heavenly existence,
or condemn them to be devoured by Ammit. Indeed, Anubis was a Policy Enforcement
system for souls :)

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

(The schema is editable at [asciiflow](https://asciiflow.com/#/share/eJyrVspLzE1VssorzcnRUcpJrEwtUrJSqo5RqohRsrI0N9aJUaoEsozMLYCsktSKEiAnRkkBO3g0ZQ%2FxKCYmD7cxYNoxwBPGJ6Q4uCA1OTMtM5koxQpBpTmpxcSYTA3fwEybtomwGmLMAashyW1keYjcUEDSCtMPJA0RzID8nMzkSgRfAY2J6ksQxzknMzWvBJ9bpu0CKXXNS8svSk7NBSkmoBQEUJMXdncjMQPyM8GOIM7dgzR2cCYrJNdTQc002mcrLImJqiUKCp9avlGqVaoFAKtNRnk%3D))

1. A client requests for a resource via the Policy Enforcement Point (PEP) -
    implemented using a authz envoy
[authz filter](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/ext_authz).
1. The PEP pass over the request to the PDP (Policy Decision Point), provided by
    OPA which evaluates a set of rules that apply the abstract policies to the
    specific API to be protected
1. In combination with the policies stored in the Policy Management API,
    that acts as PAP (Policy Administration Point);
1. If the evaluation of the policies returns `allowed`, then the request is
    forwarded to the API.

## Policy management

Anubis currently supports only Role Based Access Control policies. Policies
are stored in the [policy management api](anubis-management-api), that supports
the translation to WAC and to a data input format supported by
[OPA](https://www.openpolicyagent.org/), the engine that performs
the policy evaluation.

At the time being, the API specific rules have been developed
specifically for the [NGSIv2 Context Broker](https://fiware-orion.readthedocs.io/en/master/),
Anubis management, and JWT-based authentication. You can see Orion rules in this
[rego file](config/opa-service/rego/context_broker_policy.rego).

### Policy format

The policy internal data format is inspired by
[Web Access control](https://solid.github.io/web-access-control-spec/).
See [policy management api](anubis-management-api) for details, and
[anubis acl vocabulary](oc-acl.ttl) for formal definition.

In general, a policy is defined by:

- *actor*: The user, group or role, that is linked to the policy
- *action*: The action allowed on this resource (e.g. acl:Read for GET requests)
- *resource*: The urn of the resource being targeted (e.g. urn:entity:x)
- *resource_type*: The type of the resource.

For the authorisation rules currently in place, the supported resource types
are:

- *entity*: NGSI entity
- *entity_type*: NGSI entity type
- *subscription*: NGSI subscription
- *policy*: A policy of the Anubis Management API (to allow users to have
  control over the policies that are created)
- *tenant*: A tenant (or Fiware service)
- *service_path*: A Fiware service path under a given tenant.

This can be extended by creating new
[authorisation rules](config/opa-service/rego), and setting up the necessary
filters in the [envoy configuration](config/opa-service/v3.yaml).

Additionally, in relation to FIWARE APIs, a policy may include also:

- *tenant*: The tenant this permission falls under
- *service_path*: The service path this permission falls under

## Authentication

The authentication per se is not covered by the PEP, the assumption is that
the client authenticates before issuing and obtains a valid JWT token.

Currently the PEP only verifies that the token is valid by checking against its
expiration.

Of course, more complex validations are possible.
See [OPA Docs](https://www.openpolicyagent.org/docs/latest/oauth-oidc/)
for additional examples.

Currently, the token, when decoded, should contain:

- The ID of the user making the request
- The groups the user belongs to and their respective tenants
- The roles the user has under their respective tenants

## Demo

### Requirements

To run this demo you'll need to have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [curl](https://www.cyberciti.biz/faq/how-to-install-curl-command-on-a-ubuntu-linux/)
- [jq](https://stedolan.github.io/jq/download/)

### Deployment

To deploy the demo that includes the Auth API, OPA, Keycloak, and a Context
Broker, run the following script:

```bash
$ source .env
$ cd scripts
$ ./run_demo.sh
```

You can run a script to make a few test API calls. You can run the test
script with:

```bash
$ cd scripts
$ ./test_context_broker.sh
```

To clean up the deployment after you're done, run:

```bash
$ cd scripts
$ ./clean.sh
```

In case you are using an ARM64 based architecture, before running the scripts,
use the proper image (see comment in [docker-compose](docker-compose.yaml)).

### Configuration

The following environment variables are used by the rego policy for
configuration (see the [docker-compose file](docker-compose.yaml)):

- `AUTH_API_URI`: Specifies the URI of the auth management API.
- `VALID_ISSUERS`: Specifies the valid issuers of the auth tokens
  (coming from Keycloak). This can be a list of issuers, separated by `;`.
- `VALID_AUDIENCE`: The valid aud value for token verification.

For the policy API, the following env variables are also available:

- `CORS_ALLOWED_ORIGINS`: A `;` separated list of the allowed CORS origins
  (e.g. `http://localhost;http://localhost:3000`)
- `CORS_ALLOWED_METHODS`: A `;` separated list of the allowed CORS methods
  (e.g. `GET;POST:DELETE`)
- `CORS_ALLOWED_HEADERS`: A `;` separated list of the allowed CORS headers
  (e.g. `content-type;some-other-header`)
- `DEFAULT_POLICIES_CONFIG_FILE`: Specifies the path of the configuration
  file of the default policies to create upon tenant creation.
- `DEFAULT_WAC_CONFIG_FILE`: Specifies the path of the configuration file of
  the wac serialization.
- `DB_TYPE`: The database type to be used by the API. Valid options for
  now are `postgres` and `sqlite`.

If postgres is the database being used, the following variables are available
as well:

- `DB_HOST`: The host for the database.
- `DB_USER`: The user for the database.
- `DB_PASSWORD`: The password for the database user.
- `DB_NAME`: The name of the database.

For customising the default policies that are created alongside a tenant, see
[the configuration file](config/opa-service/default_policies.yml) that's mounted
as a volume in the policy-api service from the
[docker-compose file](docker-compose.yaml).

Similarly, a [configuration file](config/opa-service/default_wac_config.yml)
for the wac serialization is available to configure the prefixes and URIs of
the various resource types in relation to tenants.

## Test rego

To test the rego policy locally:

1. Install the opa client, e.g.:

      ```bash
      cd scripts
      curl -L -o opa https://openpolicyagent.org/downloads/v0.37.2/opa_linux_amd64_static
      chmod 755 ./opa
      ```

1. Run:

      ```bash
      $ source .env
      $ test_rego.sh
      ```

## Status and Roadmap

[Release Notes](RELEASE_NOTES.md) provide a summary of implemented features and
fixed bugs.

For additional planned features you can
check the pending [issues](https://github.com/orchestracities/anubis/issues)
and their mapping to [milestones](https://github.com/orchestracities/anubis/milestones).

## Credits

- [JSON.lua package](config/opa-service/lua/JSON.lua) by Jeffrey Friedl

## Sponsors

- Anubis received funding as part of the Cascade Funding mechanisms of the EC
  project [DAPSI](https://dapsi.ngi.eu/) - GA 871498.
