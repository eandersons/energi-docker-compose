#!/bin/sh
# A wrapper script to load chain data in the Energi Core Node container
docker-compose stop
docker-compose run --entrypoint '/bin/sh bootstrap-chaindata.sh' --rm core
docker-compose up --detach
