#!/bin/sh

docker-compose run --entrypoint='/bin/bash nodemon.sh' --rm --user=root monitor
