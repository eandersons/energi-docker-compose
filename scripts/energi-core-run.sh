#!/bin/sh
# A script to be used as a Docker container entrypoint to run
# Energi Core node and unlock account for staking.

/usr/bin/nc -lk -p 65432 -e ./netcat-ps.sh &
/usr/bin/nc -lk -p 65434 -e ./netcat-pgrep.sh &
. ./energi_command.sh
# https://wiki.energi.world/docs/guides/core-node-linux#22-setup-auto-start
# Section "2.2.1.2 - Mainnet"
exec ${energi_command} \
  --gcmode archive \
  --masternode \
  --maxpeers 128 \
  --mine=1 \
  --nat extip:"$(wget -qO- https://api.ipify.org)" \
  --nousb \
  --password /run/secrets/account_password \
  --unlock "$(cat /run/secrets/account_address)" \
  --unlock.staking \
  --verbosity 3
