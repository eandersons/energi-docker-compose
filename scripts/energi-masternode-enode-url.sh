#!/bin/sh
enode='admin.nodeInfo.enode'

printf '%s:\n' ${enode} &&
  ${ENERGI_BIN} --datadir="${ENERGI_CORE_DIR}" attach --exec ${enode}

exit ${?}
