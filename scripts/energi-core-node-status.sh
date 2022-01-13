#!/bin/sh

exec="${ENERGI_BIN} --datadir=${ENERGI_CORE_DIR} attach --exec"
status='miner.stakingStatus()'
syncing='nrg.syncing'

printf '%b:\n' ${syncing} && ${exec} ${syncing} \
&& printf '%b:\n' ${status} && ${exec} ${status}

exit $?
