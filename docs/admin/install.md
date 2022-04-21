# Install

TBD

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
| `DATABASE_TYPE`                | The database type to be used by the API. Valid options for now are `postgres` and `sqlite`.|
| `POSTGRES_HOST`                | The host for the postgres database.|
| `POSTGRES_USER`                | The postgres user for the database.|
| `POSTGRES_PASSWORD`            | The password of the postgres user.|
| `POSTGRES_DB`                  | The name of the postgres database.|
