#!/bin/bash -e

cd ..
echo "Building image and initiating API for testing..."
docker build -f Dockerfile-api -t apitest .
docker run -d --rm --name apitest -p 8000:8000 apitest
sleep 10
echo "API Up. Running rego tests..."
opa test ./config -v
echo "Tests completed, cleaning up docker container..."
docker rm -fv apitest
echo "Done"
