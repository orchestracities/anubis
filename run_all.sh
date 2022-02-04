#!/bin/bash -e

cd ./keycloak
wget https://github.com/orchestracities/keycloak-scripts/releases/download/v0.0.4/oc-custom.jar -O oc-custom.jar
cd ..
docker-compose up
