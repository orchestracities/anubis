#!/bin/bash -e

echo "Download open api spec"
curl http://localhost:8085/openapi.json | jq '.' > ../open-api-spec/openapi.json
echo "Done"
