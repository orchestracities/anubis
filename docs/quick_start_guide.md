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

To deploy the demo that includes the Auth API, OPA, Keycloak, and a Context
To deploy the the architecture above, use git to clone the repository and 
launch the docker compose:

```bash
$ git clone https://github.com/orchestracities/anubis.git
$ cd anubis
$ source .env
$ docker compose up -d
```

Verify that all services are up and running (it ):
```bash
$ docker compose ps
```

