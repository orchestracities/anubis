#!/bin/bash -e

echo "Obtaining token from Keycloak..."

export token=`curl -d "client_id=client1&grant_type=password&username=admin&password=admin" -X POST --header "Host: keycloak:8080" 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' | \
jq '.access_token'`

export token="${token%\"}"
export token="${token#\"}"

echo "\n\ncan i read entities?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8000/v2/entities'


echo "\n\ncan i create an entity at / in Tenant1?"
curl -i --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: Tenant1' \
--header 'fiware-ServicePath: /' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "id": "urn:ngsi-ld:AirQualityObserved:demo",
  "type": "AirQualityObserved",
  "address": {
    "type": "PostalAddress",
    "value": {
      "addressCountry": "CH",
      "addressLocality": "Dietikon",
      "streetAddress": "Ueberlandstrasse"
    },
    "metadata": {}
  },
  "airQualityIndex": {
    "type": "Number",
    "value": 65,
    "metadata": {}
  },
  "CO": {
    "type": "Number",
    "value": 500,
    "metadata": {}
  },
  "dataProvider": {
    "type": "Text",
    "value": "http://demo",
    "metadata": {}
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2019-06-95T11:00:00",
    "metadata": {}
  },
  "location": {
    "type": "geo:json",
    "value": {
      "type": "Point",
      "coordinates": [
        8.4089862,
        47.4082054
      ]
    },
    "metadata": {}
  },
  "NO": {
    "type": "Number",
    "value": 45,
    "metadata": {}
  },
  "NO2": {
    "type": "Number",
    "value": 69,
    "metadata": {}
  },
  "O3": {
    "type": "Number",
    "value": 139,
    "metadata": {}
  },
  "PM1": {
    "type": "Number",
    "value": 10,
    "metadata": {}
  },
  "PM2_5": {
    "type": "Number",
    "value": 4,
    "metadata": {}
  },
  "PM10": {
    "type": "Number",
    "value": 3,
    "metadata": {}
  },
  "pressure": {
    "type": "Number",
    "value": 0.54,
    "metadata": {}
  },
  "refDevice": {
    "type": "Relationship",
    "value": "urn:ngsi-ld:AirQualityObserved:Device:demo",
    "metadata": {}
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 0.68,
    "metadata": {}
  },
  "reliability": {
    "type": "Number",
    "value": 0.7,
    "metadata": {}
  },
  "SO2": {
    "type": "Number",
    "value": 11,
    "metadata": {}
  },
  "temperature": {
    "type": "Number",
    "value": 12.2,
    "metadata": {}
  }
}'

echo "\n\ncan i create an entity at /Path1 in Tenant1?"
curl -i --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: EKZ' \
--header 'fiware-ServicePath: /Path1' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "id": "urn:ngsi-ld:AirQualityObserved:demo",
  "type": "AirQualityObserved",
  "address": {
    "type": "PostalAddress",
    "value": {
      "addressCountry": "CH",
      "addressLocality": "Dietikon",
      "streetAddress": "Ueberlandstrasse"
    },
    "metadata": {}
  },
  "airQualityIndex": {
    "type": "Number",
    "value": 65,
    "metadata": {}
  },
  "CO": {
    "type": "Number",
    "value": 500,
    "metadata": {}
  },
  "dataProvider": {
    "type": "Text",
    "value": "http://demo",
    "metadata": {}
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2019-06-95T11:00:00",
    "metadata": {}
  },
  "location": {
    "type": "geo:json",
    "value": {
      "type": "Point",
      "coordinates": [
        8.4089862,
        47.4082054
      ]
    },
    "metadata": {}
  },
  "NO": {
    "type": "Number",
    "value": 45,
    "metadata": {}
  },
  "NO2": {
    "type": "Number",
    "value": 69,
    "metadata": {}
  },
  "O3": {
    "type": "Number",
    "value": 139,
    "metadata": {}
  },
  "PM1": {
    "type": "Number",
    "value": 10,
    "metadata": {}
  },
  "PM2_5": {
    "type": "Number",
    "value": 4,
    "metadata": {}
  },
  "PM10": {
    "type": "Number",
    "value": 3,
    "metadata": {}
  },
  "pressure": {
    "type": "Number",
    "value": 0.54,
    "metadata": {}
  },
  "refDevice": {
    "type": "Relationship",
    "value": "urn:ngsi-ld:AirQualityObserved:Device:demo",
    "metadata": {}
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 0.68,
    "metadata": {}
  },
  "reliability": {
    "type": "Number",
    "value": 0.7,
    "metadata": {}
  },
  "SO2": {
    "type": "Number",
    "value": 11,
    "metadata": {}
  },
  "temperature": {
    "type": "Number",
    "value": 12.2,
    "metadata": {}
  }
}'

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo attributes?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo temperature?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs/temperature
