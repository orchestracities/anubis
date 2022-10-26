# Policy Governance Middleware

This API provides functionalities to synchronize policies across different
Anubis Management APIs instances.

It's a proof of concept not yet suitable for production.

## Development set-up

Requirements: node 16+

1. Install dependencies:

    ```bash
    npm install
    ```

1. Launch two api instances using the provided
    `docker-compose-middleware-dev.yaml` docker compose.

    ```bash
    docker compose -f docker-compose-middleware-dev.yaml up -d
    ```

1. Launch two instances of the middleware using different config.
  To launch the first instance:

    ```bash
    SERVER_PORT=8098 \
    ANUBIS_API_URI=localhost:8085 \
    LISTEN_ADDRESS=/dnsaddr/127.0.0.1/tcp/49662 \
    IS_PRIVATE_ORG=false \
    node src/main.js
    ```

  To launch the second instance (in a separate shell):

    ```bash
    SERVER_PORT=8099 \
    ANUBIS_API_URI=localhost:8086 \
    LISTEN_ADDRESS=/dnsaddr/127.0.0.1/tcp/49663 \
    IS_PRIVATE_ORG=false \
    node --inspect src/main.js
    ```
