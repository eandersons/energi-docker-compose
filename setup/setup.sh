#!/bin/sh
# A helper script to do a one time setup to use `energi-docker-compose`
data_directory="$( basename "${ENERGI_CORE_DIR}" )"
keystore_path="${data_directory}/keystore"
staker_keystore_path="${STAKER_HOME}/${keystore_path}"
user="$( basename "${STAKER_HOME}" )"

mkdir --parent "${staker_keystore_path}" \
&& mv "/setup/${keystore_path}/*" "${staker_keystore_path}"
chown -R "${user}:${user}" "${ENERGI_CORE_DIR}"
