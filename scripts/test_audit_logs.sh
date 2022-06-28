#!/bin/bash -e

echo "Can I read all audit logs?"
echo "==============================================================="

export response=`curl -s -o /dev/null -w "%{http_code}" -H "accept: application/json" -H "fiware-service: Tenant1" -H "fiware-servicepath: /" 'http://localhost:8085/v1/audit/logs?skip=0&limit=100'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't read audit logs"
  exit 1
fi

echo ""
