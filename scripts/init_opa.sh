#!/bin/sh -e

apk update
apk add curl jq

curl -s -X 'GET' \
"${AUTH_API_URI}/v1/tenants/" \
-o tenants.json

cat tenants.json | jq -r '.[] | .name' | while read object; do
  echo "fiware-service: ${object}"
  curl -s -X 'GET' \
  "${AUTH_API_URI}/v1/policies/" \
  -H 'accept: text/rego' \
  -H "fiware-service: ${object}" \
  -H 'fiware-servicepath: /' \
  -o policies.json

  cat policies.json

  curl -s -i -X 'PUT' \
  "${OPA_ENDPOINT}/v1/data/Tenant1/policies" \
  -H 'Content-Type: application/json' \
  -d "@policies.json"
done
