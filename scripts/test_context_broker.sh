#!/bin/bash -e

echo "Obtaining token from Keycloak..."

export token=`curl -s -d "client_id=client1&grant_type=password&username=admin&password=admin" -X POST --header "Host: keycloak:8080" 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' | \
jq -j '.access_token'`

echo "Can I read all entities?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8000/v2/entities'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read entities"
  exit 1
fi

echo ""

echo "Can I get link to policies?"
echo "==============================================================="
export response=`curl -s -o /dev/null -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" -D - 'http://localhost:8000/v2/entities' | grep -i 'link'`
if [[ ! -z "$response" ]]
then
  echo "PASSED"
  echo "VALUE: $response"
else
  echo "ERROR: Can't read policy link"
  exit 1
fi

echo ""

echo "Can I create an entity in ServicePath / for Tenant1?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: Tenant1' \
--header 'fiware-ServicePath: /' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "id": "urn:ngsi-ld:AirQualityObserved:demo",
  "type": "AirQualityObserved",
  "temperature": {
    "type": "Number",
    "value": 12.2,
    "metadata": {}
  }
}'`
if [ $response == "201" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't create entity"
  exit 1
fi

echo ""

echo "Has the Control policy for the entity urn:ngsi-ld:AirQualityObserved:demo been created?"
echo "==============================================================="
export response=`curl -s -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8090/v1/policies/' | jq '[.[].access_to | select(. == "urn:ngsi-ld:AirQualityObserved:demo")] | length'`
if [ $response == 1 ]
then
  echo "PASSED"
else
  echo "ERROR: Policy for entity urn:ngsi-ld:AirQualityObserved:demo wasn't automatically created"
  exit 1
fi

echo ""

echo "Can I create an entity at /Path1 in Tenant1? (Shouldn't be able to here)"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: EKZ' \
--header 'fiware-ServicePath: /Path1' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "id": "urn:ngsi-ld:AirQualityObserved:demo",
  "type": "AirQualityObserved",
  "temperature": {
    "type": "Number",
    "value": 12.2,
    "metadata": {}
  }
}'`
if [ $response == "403" ]
then
  echo "PASSED"
else
  echo "ERROR: Can create entity, but shouldn't be able to"
  exit 1
fi

echo ""

echo "Can I read entity urn:ngsi-ld:AirQualityObserved:demo?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read entity"
  exit 1
fi

echo ""

echo "Can I read entity urn:ngsi-ld:AirQualityObserved:demo attributes?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read entity attributes"
  exit 1
fi

echo ""

echo "Can I read entity urn:ngsi-ld:AirQualityObserved:demo temperature?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs/temperature`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read entity attributes"
  exit 1
fi

echo ""

echo "Can I delete entity urn:ngsi-ld:AirQualityObserved:demo?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request DELETE -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo`
if [ $response == "204" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't delete entity"
  exit 1
fi

echo ""

echo "Can I read all entities in Tenant2 with the default policy of acl:Read set?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $token" -H "fiware-service: Tenant2" -H "fiware-servicepath: /" 'http://localhost:8000/v2/entities'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read entities in Tenant2 with default policy of acl:Read"
  exit 1
fi

echo ""
