#!/bin/bash

ip_address() {
  if [[ "${ECNM_SHOW_IP_EXTERNAL:-n}" == 'y' ]]; then
    IP_ADDRESS="$(wget -qO- https://api.ipify.org)"
  else
    IP_ADDRESS="$(hostname -i)"
  fi

  printf '%s' "${IP_ADDRESS}"
}

market_price() {
  if [[ -z "${NRGMKTPRICE}" ]]; then
    timestamp="${1}"
    endpoint="https://min-api.cryptocompare.com/data/price?fsym=NRG&tsyms=${CURRENCY}"

    if [[ -n "${timestamp}" ]]; then
      endpoint="${endpoint}&ts=${timestamp}"
    fi

    NRGMKTPRICE="$(curl \
      --connect-timeout 30 \
      --header "Accept: application/json" \
      --silent \
      "${endpoint}" |
      jq ".${CURRENCY}")"
  fi
}

message_date() {
  TZ="${MESSAGE_TIME_ZONE}" date -R
}

override_read() {
  if value_to_bool "${INTERACTIVE}"; then
    printf '%s\n' "${1}"
    REPLY="${1}"
  else
    read -e -i "${1}" -r
  fi
}

total_node_balance() {
  masternode_collateral=${1}
  staking_balance=${2}
  printf '%s' "$(printf '%s\n' "${masternode_collateral} + ${staking_balance}" |
    bc -l |
    sed '/\./ s/\.\{0,1\}0\{1,\}$//')"
}

value_to_bool() {
  value="${1,,}"

  if
    [[ "${value}" == 'y' ]] ||
      [[ "${value}" == 'yes' ]] ||
      [[ "${value}" == 'true' ]] ||
      [[ "${value}" -eq 1 ]]
  then
    return 0
  fi

  return 1
}
