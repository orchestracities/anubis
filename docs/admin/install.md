# Install

Anubis is available as a [docker container](https://hub.docker.com/r/orchestracities/anubis-management-api)
and as a python [package](https://pypi.org/project/anubis-policy-api/).

Requirements to allow policy enforcement using Anubis (PAP) are:

- [envoy proxy](https://www.envoyproxy.io/) acting as PEP
- [opa with envoy plugin](https://www.openpolicyagent.org/docs/latest/envoy-introduction/)
  acting as PDP
- optionally [PostgresSQL](https://postgresql.org) to store policies

An example [docker compose](https://raw.githubusercontent.com/orchestracities/anubis/master/docker-compose.yaml)
in Anubis code repository that deploy all the dependencies and demonstrates
how to protect an [Orion Context Broker](https://fiware-orion.readthedocs.io/en/master/)
instance.

To install the python package:

```bash
$ pip install anubis-policy-api
```

This will allow you to reuse Anubis apis also for other projects.

## Environment variables

| Variale                        | Description |
| ------------------------------ | ----------- |
| `AUTH_API_URI`                 | Specifies the `URI` of the auth management API. |
| `VALID_ISSUERS`                | Specifies the valid `issuers` of the auth tokens (coming from Keycloak). This can be a list of issuers, separated by `;`.|
| `VALID_AUDIENCE`               | The valid `aud` value for token verification.|
| `CORS_ALLOWED_ORIGINS`         | A `;` separated list of the allowed CORS origins (e.g. `http://localhost;http://localhost:3000`).|
| `CORS_ALLOWED_METHODS`         | A `;` separated list of the allowed CORS methods (e.g. `GET;POST;DELETE`).|
| `CORS_ALLOWED_HEADERS`         | A `;` separated list of the allowed CORS headers (e.g. `content-type;some-other-header`).|
| `DEFAULT_POLICIES_CONFIG_FILE` | Specifies the path of the configuration file of the default policies to create upon tenant creation.|
| `DEFAULT_WAC_CONFIG_FILE`      | Specifies the path of the configuration file of the wac serialization.|
| `KEYCLOACK_ENABLED`            | Enable creation of tenant also in Keycloak.|
| `TENANT_ADMIN_ROLE_ID`         | Specifies the path of the configuration file of the wac serialization.|
| `KEYCLOACK_ADMIN_ENDPOINT`     | The endpoint of the admin api of Keycloak.| 
| `DB_TYPE`                | The database type to be used by the API. Valid options for now are `postgres` and `sqlite`.|
| `DB_HOST`                      | The host for the database.|
| `DB_USER`                      | The user for the database.|
| `DB_PASSWORD`                  | The password of the database user.|
| `DB_NAME`                      | The name of the database.|
