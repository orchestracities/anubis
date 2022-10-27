#!/bin/bash -e

echo "Download open api spec"
sleep 5
curl http://localhost:8085/openapi.json | jq '.' > ../open-api-spec/api-manager/openapi.json
curl http://localhost:8098/api-spec/v3 | jq '.' > ../open-api-spec/middleware/openapi.json
echo "Done"
