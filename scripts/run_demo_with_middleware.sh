#!/bin/bash -e

rep=$(curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null)
status=$?

if [ $status -eq 7 ]; then
    echo 'docker is not running - test will not be executed'
    exit 1
fi

echo "Downloading Keycloak scripts..."
mkdir -p ../keycloak
cd ../keycloak
wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.6/oc-custom.jar -O oc-custom.jar
wget https://raw.githubusercontent.com/orchestracities/keycloak-scripts/master/realm-export-empty.json -O realm-export.json
cd ..

echo "Deploying services via Docker Compose..."
docker-compose -f docker-compose-middleware.yaml up -d

wait=0
HOST="http://localhost:8080"
while [ "$(curl -s -o /dev/null -L -w ''%{http_code}'' $HOST)" != "200" ] && [ $wait -le 60 ]
do
  echo "Waiting for Keycloak..."
  sleep 5
  wait=$((wait+5))
  echo "Elapsed time: $wait"
done

if [ $wait -gt 60 ]; then
  echo "timeout while waiting services to be ready"
  docker-compose -f docker-compose-middleware.yaml down -v --remove-orphans
  exit -1
fi

HOST="http://127.0.0.1:8085/v1/tenants/"
while [ "$(curl -s -o /dev/null -L -w ''%{http_code}'' $HOST)" != "200" ] && [ $wait -le 60 ]
do
  echo "Waiting for anubis..."
  sleep 5
  wait=$((wait+5))
  echo "Elapsed time: $wait"
done

if [ $wait -gt 60 ]; then
  echo "timeout while waiting services to be ready"
  docker-compose down -v
  exit -1
fi

echo "Obtaining token from Keycloak..."

export json=$( curl -sS --location --request POST 'http://localhost:8080/realms/default/protocol/openid-connect/token' \
--header 'Host: keycloak:8080' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=admin@mail.com' \
--data-urlencode 'password=admin' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=configuration')

export token=$( jq -r ".access_token" <<<"$json" )

echo ""
echo "decoded token:"
echo ""

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

echo ""
echo "Setting up tenant Tenant1 in node 1..."
echo ""
curl -s -i -X 'POST' \
  'http://127.0.0.1:8085/v1/tenants/' \
  -H 'accept: */*' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Tenant1"
}'

echo ""
echo "Setting up tenant Tenant2 in node 2..."
echo ""

curl -s -i -X 'POST' \
  'http://127.0.0.1:8086/v1/tenants/' \
  -H 'accept: */*' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Tenant2"
}'

echo ""
echo "Setting up policy in node1 for tenant Tenant1 and path / for entity urn:AirQuality:1 ..."
echo ""

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "urn:AirQuality:1",
"resource_type": "entity",
"mode": ["acl:Write"],
"agent": ["acl:agent:admin@mail.com"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "urn:AirQuality:1",
"resource_type": "entity",
"mode": ["acl:Control"],
"agent": ["acl:agent:admin@mail.com"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "urn:AirQuality:1",
"resource_type": "entity",
"mode": ["acl:Read"],
"agent": ["acl:AuthenticatedAgent"]
}'

echo "Demo deployed!"
