#!/bin/bash -e

echo "Obtaining token from Keycloak..."

export json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin@mail.com' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration'
 )

export token=$( jq -r ".access_token" <<<"$json" )

echo "\ndecoded token:\n"

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

echo "\nkeycloak response:\n"

curl 'http://localhost:8080/admin/realms/default/groups?briefRepresentation=false' \
  -H 'Accept: application/json, text/plain, */*' \
  -H "Authorization: bearer $token" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  --compressed | jq
