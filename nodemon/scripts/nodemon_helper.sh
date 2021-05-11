#!/bin/bash

function override_read {
  if [[ "${INTERACTIVE}" == 'n' ]]
  then
    echo $1
    REPLY=$1
  else
    read -e -i "$1" -r
  fi
}

function ip_address {
  if [[ "${ECNM_SHOW_IP_EXTERNAL:-n}" == 'y' ]]
  then
    IP_ADDRESS=$( wget -qO- https://api.ipify.org )
  else
    IP_ADDRESS=$( hostname -i )
  fi

  echo ${IP_ADDRESS}
}
