#!/bin/sh
# A wrapper script to apply preimages for Energi Core Node container
docker-compose run --entrypoint '/bin/sh bootstrap-chaindata.sh' --rm core
