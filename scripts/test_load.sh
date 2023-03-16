#!/usr/bin/env bash

#remember to start your demo stack

echo "Obtaining token from Keycloak..."

export json=$(curl -s -d "client_id=ngsi&client_secret=changeme&grant_type=password&username=admin@mail.com&password=admin" -X POST --header "Host: keycloak:8080" 'http://localhost:8080/realms/default/protocol/openid-connect/token')
export token=$( jq -r ".access_token" <<<"$json" )

echo ""
echo "Create urn:ngsi-ld:AirQualityObserved:demo entity in ServicePath / for Tenant1"
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
echo "Run load test with Anubis in front of Orion"
echo "==============================================================="

echo "GET http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo" | vegeta attack -header "authorization: Bearer $token" -header "fiware-Service: Tenant1" -header "fiware-servicepath: /" -rate=130 -duration=10s | tee results2.bin | vegeta report

sleep 1

echo ""
echo "Run load test without Anubis in front of Orion"
echo "==============================================================="

echo "GET http://localhost:1026/v2/entities/urn:ngsi-ld:AirQualityObserved:demo" | vegeta attack -header "fiware-Service: Tenant1" -header "fiware-servicepath: /" -rate=130 -duration=10s | tee results1.bin | vegeta report

echo ""
echo "Delete urn:ngsi-ld:AirQualityObserved:demo entity in ServicePath / for Tenant1"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request DELETE -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo`
if [ $response == "204" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't delete entity"
  exit 1
fi
