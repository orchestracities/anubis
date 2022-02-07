#!/bin/bash -e

echo "Downloading Keycloak scripts..."
cd ../keycloak
wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.4/oc-custom.jar -O oc-custom.jar
cd ..

echo "Deploying services via Docker Compose..."
docker-compose up -d

until curl -s -f -LI -o /dev/null 'http://localhost:8085'; do
  echo "Waiting for Keycloak..."
  sleep 5
done

echo "Setting up tenant Tenant1..."
curl -s -i -X 'POST' \
  'http://127.0.0.1:8080/v1/tenants/' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Tenant1"
}'

echo "Setting up policy that allows reading and creating entities under tenant Tenant1 and path / ..."
curl -s -i -X 'POST' \
'http://127.0.0.1:8080/v1/policies/' \
-H 'accept: */*' \
-H 'fiware_service: Tenant1' \
-H 'fiware_service_path: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "*",
"resource_type": "entity",
"mode": ["acl:Read"],
"agent": ["acl:AuthenticatedAgent"]
}'

curl -s -i -X 'POST' \
'http://127.0.0.1:8080/v1/policies/' \
-H 'accept: */*' \
-H 'fiware_service: Tenant1' \
-H 'fiware_service_path: /' \
-H 'Content-Type: application/json' \
-d '{
"access_to": "*",
"resource_type": "entity",
"mode": ["acl:Write"],
"agent": ["acl:AuthenticatedAgent"]
}'

echo "Demo deployed!"
