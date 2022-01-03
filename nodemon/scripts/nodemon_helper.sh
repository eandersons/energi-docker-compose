#!/bin/bash

ip_address () {
  if [[ "${ECNM_SHOW_IP_EXTERNAL:-n}" == 'y' ]]
  then
    IP_ADDRESS="$( wget -qO- https://api.ipify.org )"
  else
    IP_ADDRESS="$( hostname -i )"
  fi

  printf '%s' "${IP_ADDRESS}"
}

market_price() {
  # Get price once
  if [[ -z "${NRGMKTPRICE}" ]]
  then
    NRGMKTPRICE="$( curl \
      --connect-timeout 30 \
      --header "Accept: application/json" \
      --silent \
      "https://min-api.cryptocompare.com/data/price?fsym=NRG&tsyms=${CURRENCY}" \
      | jq ".${CURRENCY}" )"
  fi
}

message_date() {
  TZ="${MESSAGE_TIME_ZONE}" date -R
}

override_read () {
  if [[ "${INTERACTIVE}" == 'n' ]]
  then
    printf '%s\n' "${1}"
    REPLY="${1}"
  else
    read -e -i "${1}" -r
  fi
}

value_to_bool() {
  value="${1,,}"

  if [[ "${value}" == 'y' ]] \
  || [[ "${value}" == 'yes' ]] \
  || [[ "${value}" == 'true' ]] \
  || [[ "${value}" -eq 1 ]]
  then
    return 0
  fi

  return 1
}
