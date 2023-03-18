#!/bin/sh
# A script to bootstrap chaindata for Energi Core Node container
# https://docs.energi.software/en/core-node-troubleshoot#bootstrap
. ./energi_command.sh
cd "${ENERGI_CORE_DIR}" || exit
yes | ${energi_command} removedb
curl -s https://s3-us-west-2.amazonaws.com/download.energi.software/releases/chaindata/mainnet/gen3-chaindata.tar.gz \
  | tar xvz --strip-components 1
