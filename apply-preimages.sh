#!/bin/sh
# A wrapper script to apply preimages for Energi Core Node container
docker-compose run --entrypoint '/bin/sh apply-preimages.sh' core
