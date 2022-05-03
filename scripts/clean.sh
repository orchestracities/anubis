#!/bin/bash -e

docker-compose down -v
docker-compose rm -fv
docker image rm orchestracities/anubis-management-api:test
