#!/bin/sh -e

apk update
apk add curl

curl -s -i -X 'GET' \
$AUTH_API_URI \
-H 'accept: text/rego' \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-o policies.json

curl -s -i -X 'PUT' \
"${OPA_ENDPOINT}/v1/data/Tenant1/policies" \
-H 'Content-Type: application/json' \
-d "@policies.json"
