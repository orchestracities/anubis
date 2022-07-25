#!/bin/bash -e

docker-compose down -v
docker-compose rm -fv
docker image rm orchestracities/anubis-management-api:test
docker image rm orchestracities/configuration-api:latest
docker image rm orchestracities/management-ui:latest
