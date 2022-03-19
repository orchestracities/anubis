#!/bin/bash -e

echo "Does the API support CORS for localhost?"
echo "==============================================================="
export response=`curl -i -s -H "Origin: http://localhost" -H "Access-Control-Request-Method: GET" http://127.0.0.1:8085/v1/tenants/`
if [[ "$response" == *"access-control-allow-origin"* ]]
then
  echo "access-control-allow-origin header is present"
else
  echo "ERROR: CORS not setup correctly"
  exit 1
fi

echo ""

echo "Does the API support CORS for example.com?"
echo "==============================================================="
export response=`curl -i -s -H "Origin: http://example.com" -H "Access-Control-Request-Method: GET" http://127.0.0.1:8085/v1/tenants/`
if [[ "$response" == *"access-control-allow-origin"* ]]
then
  echo "ERROR: access-control-allow-origin header is present"
  exit 1
else
  echo "CORS setup correctly. http://example.com is not allowed as origin"
fi

echo ""
