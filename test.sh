#!/bin/bash -e

#export token="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJwb1A0UHVVdDZBOWYxODcxSGRzQ1MtQnRZdEo3MTVHaVZPclVJdGZCMGN3In0.eyJqdGkiOiJiZTRjNzA2YS0wYTY0LTQ0MGUtOWEwZC0yMTdlYzI0YTc2OTYiLCJleHAiOjE2MDc5OTE2NzUsIm5iZiI6MCwiaWF0IjoxNjA3OTU1Njc1LCJpc3MiOiJodHRwczovL2F1dGguZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20vYXV0aC9yZWFsbXMvZGVmYXVsdCIsInN1YiI6IjYzMWE3ODBkLWM3YTItNGI2YS1hY2Q4LWU4NTYzNDhiY2IyZSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFwaSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjU4YjkwNjQxLTM2N2QtNGEzMy1hZjZiLTgwMGFiMWRkODUwNCIsImFjciI6IjEiLCJzY29wZSI6ImVudGl0eTpkZWxldGUgZW50aXR5OmNyZWF0ZSBkZXZpY2U6ZGF0YSBwcm9maWxlIGVudGl0eXR5cGU6cmVhZCBlbnRpdHk6cmVhZCBlbnRpdHk6d3JpdGUgZW1haWwgdGVuYW50cyBzdWJzY3JpcHRpb246cmVhZCIsImZpd2FyZS1zZXJ2aWNlcyI6eyJFS1oiOlsiL1dhc3RlTWFuYWdlbWVudC9EZW1vIiwiL1BhcmtpbmdNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L1BuaSIsIi9Qb3dlck1hbmFnZW1lbnQvRXNhdmUiLCIvTW9iaWxpdHlNYW5hZ2VtZW50IiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9OYWJlbCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvT3BlbldlYXRoZXIiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1ZhaXNhbGEiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1NtYXJ0U2Vuc2UiLCIvVHJhZmZpY01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RlbW8iLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1B1cnBsZUFpciIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvS2VhY291c3RpY3MiLCIvUGFya2luZ01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQvRGF0YWtvcnVtIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9NZXRlb1N3aXNzIiwiL1BhcmtpbmdNYW5hZ2VtZW50L0RhdGFrb3J1bSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvQWVyb3F1YWwiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RhdGFrb3J1bSIsIi9QYXJraW5nTWFuYWdlbWVudC9OZWRhcCIsIi9QYXJraW5nTWFuYWdlbWVudC9DaXRpbG9nIiwiL1BhcmtpbmdNYW5hZ2VtZW50L09wZW5DaGFyZ2VNYXAiLCIvV2FzdGVNYW5hZ2VtZW50L1NlbnNvbmVvIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9XQVFJIiwiL0luZnJhc3RydWN0dXJlTWFuYWdlbWVudCIsIi9QYXJraW5nTWFuYWdlbWVudC9DbGV2ZXJjaXRpIiwiL1dhc3RlTWFuYWdlbWVudCIsIi9XYXN0ZU1hbmFnZW1lbnQvRWNvbW9iaWxlIiwiL0luZnJhc3RydWN0dXJlTWFuYWdlbWVudC9EZWNlbnRsYWIiLCIvVHJhZmZpY01hbmFnZW1lbnQvQ2l0aWxvZyIsIi9UcmFmZmljTWFuYWdlbWVudCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvQ2VzdmEiLCIvVHJhZmZpY01hbmFnZW1lbnQvSEVSRSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvSGF3YURhd2EiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L0VLWiJdfSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiYXBpIGFwaSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFwaUBla3oub3JjaGVzdHJhY2l0aWVzLmNvbSIsImxvY2FsZSI6ImVuIiwiZ2l2ZW5fbmFtZSI6ImFwaSIsImZhbWlseV9uYW1lIjoiYXBpIiwiZW1haWwiOiJhcGlAZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20ifQ.Mh-BMwUX8R7d3FD8sX9stkpifOvL-5gPez68Dmghek0aiH-ESN9I9cm1c8y8v7fRcAtTV9_XwOKoi8OC50cQQY41ZHoWfD4QVo4iN24kYaKr19DRyra1GmHra4ev0CEDhmxe3qPODFanA2mMIrfA7LmCvzrStcfdFmPs0nMv4-Ef0iGbU6-vVTMSDmqF5jzDlL__sIzRLafXdQ0cOurl0sR3CTV4UzFk3zRiUi-Z1AvTBIPNc_NJ5Fe1owz5-s8aehcD-w-9JUF5ecRA_94qjc65_D5CLtzhSC5WXmGy_UTqtMf4BZtpE_hNNvJwvfTGtsxNbq63ZGiJ6BVJScL2nQ"


export token="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJwb1A0UHVVdDZBOWYxODcxSGRzQ1MtQnRZdEo3MTVHaVZPclVJdGZCMGN3In0.eyJqdGkiOiJkZDU4NGVjYS05ZDkxLTRkZGQtOWNmYi0zZTE5MTM0MTFkNjEiLCJleHAiOjE2MDgwMDQ2OTQsIm5iZiI6MCwiaWF0IjoxNjA3OTY4Njk0LCJpc3MiOiJodHRwczovL2F1dGguZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20vYXV0aC9yZWFsbXMvZGVmYXVsdCIsImF1ZCI6WyJyZXNvdXJjZV9zZXJ2ZXIiLCJhY2NvdW50IiwiZ3Jhdml0ZWUiXSwic3ViIjoiNjMxYTc4MGQtYzdhMi00YjZhLWFjZDgtZTg1NjM0OGJjYjJlIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYXBpIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiOGE1NDkzZmUtNzdkZC00MWE5LWI4MDItOTJmYzAyMjk4ZDI4IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvcGVuaWQiLCJvZmZsaW5lX2FjY2VzcyIsIm5hbWUiLCJncm91cHMiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInVzZXIiLCJlbWFpbCJdfSwicmVzb3VyY2VfYWNjZXNzIjp7InJlc291cmNlX3NlcnZlciI6eyJyb2xlcyI6WyJlbnRpdHk6d3JpdGUiLCJlbnRpdHk6b3AiLCJlbmRwb2ludDp3cml0ZSIsImVudGl0eTpkZWxldGUiLCJkZXZpY2U6cmVhZCIsInVtYV9wcm90ZWN0aW9uIiwiZW50aXR5dHlwZTpyZWFkIiwiZGV2aWNlZ3JvdXA6d3JpdGUiLCJkZXZpY2U6Y3JlYXRlIiwicmVnaXN0cmF0aW9uOndyaXRlIiwic3Vic2NyaXB0aW9uOmNyZWF0ZSIsImFsYXJtOnJlYWQiLCJzdWJzY3JpcHRpb246cmVhZCIsImVuZHBvaW50OnJlYWQiLCJyZWdpc3RyYXRpb246cmVhZCIsImRldmljZTp3cml0ZSIsImVudGl0eTpjcmVhdGUiLCJkZXZpY2U6ZGF0YSIsImVudGl0eTpyZWFkIiwiZGV2aWNlZ3JvdXA6Y3JlYXRlIiwic3Vic2NyaXB0aW9uOndyaXRlIiwic3Vic2NyaXB0aW9uOmRlbGV0ZSIsImRldmljZWdyb3VwOnJlYWQiXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfSwiZ3Jhdml0ZWUiOnsicm9sZXMiOlsiQVBJX1BVQkxJU0hFUiIsIlVTRVIiXX19LCJzY29wZSI6ImVudGl0eTpkZWxldGUgZW50aXR5OmNyZWF0ZSBkZXZpY2U6ZGF0YSBwcm9maWxlIGVudGl0eXR5cGU6cmVhZCBlbnRpdHk6cmVhZCBlbnRpdHk6d3JpdGUgZW1haWwgdGVuYW50cyBzdWJzY3JpcHRpb246cmVhZCIsImZpd2FyZS1zZXJ2aWNlcyI6eyJFS1oiOlsiL1dhc3RlTWFuYWdlbWVudC9EZW1vIiwiL1BhcmtpbmdNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L1BuaSIsIi9Qb3dlck1hbmFnZW1lbnQvRXNhdmUiLCIvTW9iaWxpdHlNYW5hZ2VtZW50IiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9OYWJlbCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvT3BlbldlYXRoZXIiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1ZhaXNhbGEiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1NtYXJ0U2Vuc2UiLCIvVHJhZmZpY01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RlbW8iLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1B1cnBsZUFpciIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvS2VhY291c3RpY3MiLCIvUGFya2luZ01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQvRGF0YWtvcnVtIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9NZXRlb1N3aXNzIiwiL1BhcmtpbmdNYW5hZ2VtZW50L0RhdGFrb3J1bSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvQWVyb3F1YWwiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RhdGFrb3J1bSIsIi9QYXJraW5nTWFuYWdlbWVudC9OZWRhcCIsIi9QYXJraW5nTWFuYWdlbWVudC9DaXRpbG9nIiwiL1BhcmtpbmdNYW5hZ2VtZW50L09wZW5DaGFyZ2VNYXAiLCIvV2FzdGVNYW5hZ2VtZW50L1NlbnNvbmVvIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9XQVFJIiwiL0luZnJhc3RydWN0dXJlTWFuYWdlbWVudCIsIi9QYXJraW5nTWFuYWdlbWVudC9DbGV2ZXJjaXRpIiwiL1dhc3RlTWFuYWdlbWVudCIsIi9XYXN0ZU1hbmFnZW1lbnQvRWNvbW9iaWxlIiwiL0luZnJhc3RydWN0dXJlTWFuYWdlbWVudC9EZWNlbnRsYWIiLCIvVHJhZmZpY01hbmFnZW1lbnQvQ2l0aWxvZyIsIi9UcmFmZmljTWFuYWdlbWVudCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvQ2VzdmEiLCIvVHJhZmZpY01hbmFnZW1lbnQvSEVSRSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvSGF3YURhd2EiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L0VLWiJdfSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiYXBpIGFwaSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFwaUBla3oub3JjaGVzdHJhY2l0aWVzLmNvbSIsImxvY2FsZSI6ImVuIiwiZ2l2ZW5fbmFtZSI6ImFwaSIsImZhbWlseV9uYW1lIjoiYXBpIiwiZW1haWwiOiJhcGlAZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20ifQ.RUXkRNveuFmTbLz_I22dgdD58YuK4iL-s6B6-CBanVw5_muBa8eD3hSngzabrCYbNG_uPEQNghcw9NVI7OgwWzvk5-B1dM68m0Uh2ElWOEuLp7zDVVHJzzY0LMG_osuPQvxS7J-xH0ZOn2V900qfsHuyBVyk6gv7YDXce0-ir4PEE-oQLY-zT_J0gfZMGNG9x6usPANcLlnw4KBmIeV2K8xUltDfxODpzL7YrPsFwr8u6jtWeT6_BTunHNNPJw1d3hJ3Mh5_F6slOYYh8K60VwFG9_YjR8Ulf1Bu_8EmGH9Akl9-RWdzmxAi8lHjjDL38sSd6F6vwzEO2PuFYPmW-w"


echo "\n\ncan i read entities?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities


echo "\n\ncan i create an entity /Path1/Path2  EKZ?"
curl -i --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: EKZ' \
--header 'fiware-ServicePath: /Path1/Path2' \
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

echo "\n\ncan i create an entity /Path1  EKZ?"
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
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo attributes?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo temperature?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs/temperature

echo "\n\ncan i read entity ent2?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/ent2