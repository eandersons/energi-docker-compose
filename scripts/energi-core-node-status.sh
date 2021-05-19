#!/bin/sh

exec='energi3 --datadir=/home/nrgstaker/.energicore3 attach --exec'
status='miner.stakingStatus()'
syncing='nrg.syncing'

printf '%b:\n' ${syncing} && ${exec} ${syncing}\
&& printf '%b:\n' ${status} && ${exec} ${status}

exit $?
