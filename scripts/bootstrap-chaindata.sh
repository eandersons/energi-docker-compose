#!/bin/sh
# A script to bootstrap chaindata for Energi Core Node container
. ./energi_command.sh
cd "${ENERGI_CORE_DIR}" || exit
yes | ${energi_command} removedb
# https://wiki.energi.world/docs/guides/bootstrap-core-node#2-running-the-bash-script
bash -ic "$(
  wget -4qO- -o- \
    raw.githubusercontent.com/energicryptocurrency/energi3-provisioning/master/scripts/linux/sync-core-node.sh
)"
# shellcheck source=/dev/null
. ~/.bashrc
