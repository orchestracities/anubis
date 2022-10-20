#!/bin/bash -e

rep=$(curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null)
status=$?

if [ $status -eq 7 ]; then
    echo 'docker is not running - test will not be executed'
    exit 1
fi

echo "Downloading Keycloak scripts and realm..."
mkdir -p ../keycloak
cd ../keycloak
wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.5/oc-custom.jar -O oc-custom.jar
wget https://raw.githubusercontent.com/orchestracities/keycloak-scripts/master/realm-export.json -O realm-export.json
cd ..

echo "Deploying services via Docker Compose..."
docker-compose up -d

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
  docker-compose down -v
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

docker run --env MONGO_DB="mongodb://mongo:27017/graphql" --name=populateDB --network=anubis_envoymesh orchestracities/configuration-api node main/mongo/populateDB.js
docker rm -f populateDB


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
echo "Setting up tenant Tenant1..."
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
echo "Setting up tenant Tenant2..."
echo ""

curl -s -i -X 'POST' \
  'http://127.0.0.1:8085/v1/tenants/' \
  -H 'accept: */*' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Tenant2"
}'

echo ""
echo "Setting up policy that allows creating entities under tenant Tenant1 and path / ..."
echo ""

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "*",
"resource_type": "entity",
"mode": ["acl:Write"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "*",
"resource_type": "entity",
"mode": ["acl:Control"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "*",
"resource_type": "policy",
"mode": ["acl:Read"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "*",
"resource_type": "policy",
"mode": ["acl:Write"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "Tenant1",
"resource_type": "tenant",
"mode": ["acl:Read"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "Tenant1",
"resource_type": "tenant",
"mode": ["acl:Write"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "/",
"resource_type": "service_path",
"mode": ["acl:Read"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
-H "Authorization: Bearer $token" \
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "/",
"resource_type": "service_path",
"mode": ["acl:Write"],
"agent": ["acl:AuthenticatedAgent"]
}'

if [[ $1 == "silent" ]]; then
  echo ""
  echo "Demo deployed!"
else
  echo ""
  echo "Your browser will open at: http://localhost:3000"
  echo "User: admin@mail.com / Password: admin"
  if [ "$(uname)" == "Darwin" ]; then
      open http://localhost:3000
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
      xdg-open http://localhost:3000
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
      start http://localhost:3000
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
      start http://localhost:3000
  fi
fi
