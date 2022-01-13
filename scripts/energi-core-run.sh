#!/bin/sh
# A script to be used as a Docker container entrypoint to run
# Energi Core node and unlock account for staking.

/usr/sbin/sshd -f "${SSHD_DIR}/sshd_config"

# https://wiki.energi.world/en/3-1/advanced/core-node-linux#h-2212-mainnet (
# section "2.2.1.2 Mainnet")
exec ${ENERGI_BIN} \
  --datadir "${ENERGI_CORE_DIR}" \
  --gcmode archive \
  --masternode \
  --maxpeers 128 \
  --mine=1 \
  --nat extip:"$( wget -qO- https://api.ipify.org )" \
  --nousb \
  --password /run/secrets/account_password \
  --unlock "$( cat /run/secrets/account_address )" \
  --unlock.staking \
  --verbosity 3
