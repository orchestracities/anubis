#!/bin/bash -e

echo "Obtaining token from Keycloak..."

export json=$(curl -d "client_id=configuration&grant_type=password&username=admin@mail.com&password=admin" -X POST --header "Host: keycloak:8080" 'http://localhost:8080/realms/default/protocol/openid-connect/token')
export token=$( jq -r ".access_token" <<<"$json" )

echo ""
echo "decoded token:"
echo ""

jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $( jq -r ".access_token" <<<"$json" )

echo "Can I read all policies?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8090/v1/policies/'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read policies"
  exit 1
fi

echo ""

echo "Can I create a policy in ServicePath / for Tenant1?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8090/v1/policies/' \
--header 'Content: application/json' \
--header 'fiware-Service: Tenant1' \
--header 'fiware-ServicePath: /' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "access_to": "some_entity",
  "resource_type": "entity",
  "mode": ["acl:Read"],
  "agent": ["acl:AuthenticatedAgent"]
}'`
if [ $response == "201" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't create policy"
  exit 1
fi

echo ""

echo "Can I create the same policy in ServicePath / for Tenant1 (wouldn't be able to)?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8090/v1/policies/' \
--header 'Content: application/json' \
--header 'fiware-Service: Tenant1' \
--header 'fiware-ServicePath: /' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "access_to": "some_entity",
  "resource_type": "entity",
  "mode": ["acl:Read"],
  "agent": ["acl:AuthenticatedAgent"]
}'`
if [ $response == "422" ]
then
  echo "PASSED"
else
  echo "ERROR: Created duplicate policy"
  exit 1
fi

echo ""

echo "Can I create a policy in ServicePath / for Tenant2? (shouldn't be able to)"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8090/v1/policies/' \
--header 'Content: application/json' \
--header 'fiware-Service: Tenant2' \
--header 'fiware-ServicePath: /' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "access_to": "some_entity",
  "resource_type": "entity",
  "mode": ["acl:Read"],
  "agent": ["acl:AuthenticatedAgent"]
}'`
if [ $response == "403" ]
then
  echo "PASSED"
else
  echo "ERROR: Can create policy"
  exit 1
fi

echo ""

echo "Can I read Tenant1?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8090/v1/tenants/Tenant1'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read Tenant1"
  exit 1
fi

echo ""

echo "Can I create a servicepath under ServicePath / for Tenant1?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8090/v1/tenants/Tenant1/service_paths' \
--header 'Content: application/json' \
--header 'fiware-Service: Tenant1' \
--header 'fiware-ServicePath: /' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "path": "/somepath"
}'`
if [ $response == "201" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't create service path"
  exit 1
fi

echo ""

echo "Can I read my policies without token?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8090/v1/policies/me'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read policies"
  exit 1
fi

echo "Can I read my policies with the token?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8090/v1/policies/me'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read policies"
  exit 1
fi

echo ""
