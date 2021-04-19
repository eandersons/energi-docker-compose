#!/bin/sh
# A wrapper script to setup `energi3-docker-compose`
docker-compose run\
 --entrypoint '/bin/sh /setup/setup.sh'\
 --rm\
 --user=root\
 --volume="${PWD}/setup:/setup"\
 core &&
/bin/sh bootstrap-chaindata.sh &&
docker-compose up --detach
