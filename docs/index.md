# Welcome to Anubis

Anubis is a flexible Policy Enforcement solution
that makes easier to reuse security policies across different services,
assuming the policies entail the same resource.
In short we are dealing with policy portability :) What do you mean by that?

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
formalisation of data representation: the emphasis is rarely put
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

## Manuals

The [User Manual](user/index.md) and the [Admin Guide](admin/index.md)
cover more advanced topics.
