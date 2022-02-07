#!/bin/bash -e

export token="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NDQyMzg3MzYsImlhdCI6MTY0NDIzODY3NiwianRpIjoiNDJkYTgwMjEtM2IyZi00M2Y3LThjNjQtNGU5ZWRjMjRiNGI3IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDg1L2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjVjNjdiMjUxLTZmNjMtNDZmMy1iM2IwLTA4NWUxZjcwNDBiMiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNsaWVudDEiLCJzZXNzaW9uX3N0YXRlIjoiMmNkNjlkYWMtZDg3Mi00Mjg4LThiY2QtNmEwNDAwOTAxN2Y5IiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6IjJjZDY5ZGFjLWQ4NzItNDI4OC04YmNkLTZhMDQwMDkwMTdmOSIsInRlbmFudHMiOlt7Im5hbWUiOiJUZW5hbnQxIiwiZ3JvdXBzIjpbeyJyZWFsbVJvbGVzIjpbXSwibmFtZSI6Ikdyb3VwMSIsImlkIjoiNTczNjkyMDktYWU1Yy00OWMxLWJhYzctODJjMTZjMzAyOWJmIiwiY2xpZW50Um9sZXMiOlsicm9sZTEiXX1dLCJpZCI6ImI2OTFmMTVkLWQ0NzUtNGM5ZC05N2Y3LWVlOGVjMThhZTI2MiJ9LHsibmFtZSI6IlRlbmFudDIiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAyIiwiaWQiOiI5YjJjMmMzZS1lM2NkLTQ3NTgtOWUxNC1iMDA1ZmVlZjA2ZjEiLCJjbGllbnRSb2xlcyI6WyJyb2xlMiJdfV0sImlkIjoiYTY2NjJlM2YtMDMyOC00M2QxLWI1Y2YtMjVmMzIwOWM1N2U4In1dLCJmaXdhcmUtc2VydmljZXMiOnsiVGVuYW50MSI6WyIvU2VydmljZVBhdGgxIl0sIlRlbmFudDIiOlsiL1NlcnZpY2VQYXRoMiJdfSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiJ9.Hvi9byFSgO1lO1-rmkUcnrZfK0kiTu1uDdBJVaGD_fm9cqS_FztlsP2VRn1E33GctGGwapgfHec-wnULMeH4QBspXpCsm9ZRAfdLAb7apN3OLtFHIrD9i0PjqZugN_rZhMKspOECU6rwzA93Q9MMGvdBhsoq4yuaRm2zRA2C2p0Mf0Qbate1kexUv3coVAY_pwLB25kM9a1VaRs6wFJzapsrGwMfyJ8qUelSXqs7dhBrAPAZMtJsYweMr8wbNB8VbaZjl4Ov-dHhUpdyBIAwVkYti8A8JhLri0lyVIMSoEO6RUx-lW7yLZuSEfkKEfpwl5LedCM2VO0XoQKHkTNsaw"


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
