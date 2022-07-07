#!/bin/bash -e

rep=$(curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null)
status=$?

if [ $status -eq 7 ]; then
    echo 'docker is not running - test will not be executed'
    exit 1
fi

echo "Downloading Keycloak scripts..."
cd ../keycloak
wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.4/oc-custom.jar -O oc-custom.jar
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

docker run --env MONGO_DB="mongodb://mongo:27017/graphql" --network=anubis_envoymesh orchestracities/configuration-api node main/mongo/populateDB.js

echo "Setting up tenant Tenant1..."
curl -s -i -X 'POST' \
  'http://127.0.0.1:8085/v1/tenants/' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Tenant1"
}'

echo "Setting up tenant Tenant2..."
curl -s -i -X 'POST' \
  'http://127.0.0.1:8085/v1/tenants/' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Tenant2"
}'

echo "Setting up policy that allows creating entities under tenant Tenant1 and path / ..."

curl -s -i -X 'POST' \
'http://127.0.0.1:8085/v1/policies/' \
-H 'accept: */*' \
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
-H 'fiware-service: Tenant1' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "/",
"resource_type": "service_path",
"mode": ["acl:Write"],
"agent": ["acl:AuthenticatedAgent"]
}'

echo "Demo deployed!"

echo "Your browser will open at: http://localhost:3000"
echo "User: admin / Password: admin"
if [ "$(uname)" == "Darwin" ]; then
    open http://localhost:3000
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    xdg-open http://localhost:3000
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    start http://localhost:3000
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    start http://localhost:3000
fi
