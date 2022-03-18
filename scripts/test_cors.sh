#!/bin/bash -e

echo "Does the API support CORS?"
echo "==============================================================="
export response=`curl -i -s -H "Origin: http://localhost" http://127.0.0.1:8000/v1/tenants/`
if [[ "$response" == *"access-control-allow-origin"* ]]
then
  echo "access-control-allow-origin header is present"
else
  echo "ERROR: CORS not setup correctly"
fi

echo ""
