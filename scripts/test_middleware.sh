echo ""
echo "Get metadata from node 1?"
echo "==============================================================="

export response=`curl -s -o /dev/null -w "%{http_code}" --request GET 'http://localhost:8098/metadata'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't get metadata"
  exit 1
fi

echo ""
echo "Get metadata from node 2?"
echo "==============================================================="

export response=`curl -s -o /dev/null -w "%{http_code}" --request GET 'http://localhost:8099/metadata'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't get metadata"
  exit 1
fi


# TODO: THIS IS REQUIRED UNTIL WE DON'T INJECT SUBSCRITION IN LUA
echo ""
echo "Can subscribe node 1 for urn:AirQuality:1? (destination tenant 1)"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8098/resource/urn:AirQuality:1/subscribe' --header 'fiware-Service: Tenant1' --header 'fiware-Servicepath: /'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't subscribe"
  exit 1
fi

echo ""
echo "Can retrieve mobile data from node 2 for user admin@mail.com?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request GET 'http://localhost:8099/user/policies' --header 'user: admin@mail.com'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't get user data"
  exit 1
fi

echo ""
echo "Node 1 has 3 policies for urn:AirQuality:1 in Tenant1"
echo "==============================================================="
export response=`curl -s -X 'GET' 'http://localhost:8085/v1/policies/?resource=urn%3AAirQuality%3A1&skip=0&limit=100' -H 'accept: application/json' -H 'fiware-service: Tenant1' -H 'fiware-servicepath: /#' | jq length`
if [ $response == "3" ]
then
  echo "PASSED"
else
  echo "ERROR"
  exit 1
fi

echo ""
echo "Node 2 has 0 policies for urn:AirQuality:1 in Tenant2"
echo "==============================================================="
export response=`curl -s -X 'GET' 'http://localhost:8086/v1/policies/?resource=urn%3AAirQuality%3A1&skip=0&limit=100' -H 'accept: application/json' -H 'fiware-service: Tenant2' -H 'fiware-servicepath: /#' | jq length`
if [ $response == "0" ]
then
  echo "PASSED"
else
  echo "ERROR"
  exit 1
fi

echo ""
echo "Can subscribe node 2 for urn:AirQuality:1 (destination tenant 2)?"
echo "==============================================================="
export response=`curl -s -o /dev/null -w "%{http_code}" --request POST 'http://localhost:8099/resource/urn:AirQuality:1/subscribe' --header 'fiware-Service: Tenant2' --header 'fiware-Servicepath: /'`
if [ $response == "200" ]
then
  echo "PASSED"
else
  echo "ERROR: Can't subscribe"
  exit 1
fi

echo ""
echo "Node 2 now has 3 policies for urn:AirQuality:1 in Tenant2"
echo "==============================================================="
export response=`curl -s -X 'GET' 'http://localhost:8086/v1/policies/?resource=urn%3AAirQuality%3A1&skip=0&limit=100' -H 'accept: application/json' -H 'fiware-service: Tenant2' -H 'fiware-servicepath: /#' | jq length`
if [ $response == "3" ]
then
  echo "PASSED"
else
  echo "ERROR"
  exit 1
fi
