#!/bin/bash -e

docker-compose down -v
docker-compose rm -fv
docker image rm opa-authz_policy-api:latest
