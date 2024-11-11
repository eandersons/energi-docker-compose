# Build the binary `energi3` in a stock Go builder container
FROM golang:1.21-bookworm AS energi-builder

ARG ENERGI_VERSION
ARG working_dir=energi

RUN apt-get update && \
  apt-get install --assume-yes --no-install-recommends --quiet \
    musl-dev=1.2.3-1 && \
  git clone --branch ${ENERGI_VERSION:?} --depth 1 \
    https://github.com/energicryptocurrency/go-energi.git energi
WORKDIR "${working_dir}"
RUN make geth


FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG ECNM_DATA_DIR=/var/multi-masternode-data/nodebot
ARG ENERGI_BIN
ARG ENERGI_CORE_DIR
ARG LOG_DIR=/var/log
ARG USER_AND_GROUP_ID=1000
ARG USERNAME=nrgstaker
ARG STAKER_HOME
ARG NODEMON_LOG_DIR=${STAKER_HOME}/log

ENV ENERGI_BIN="${ENERGI_BIN:?}"
ENV ENERGI_CORE_DIR="${ENERGI_CORE_DIR:?}"
ENV STAKER_HOME=${STAKER_HOME:?}

RUN apt-get update --quiet && \
  apt-get upgrade --assume-yes --quiet && \
  apt-get install --assume-yes --no-install-recommends --quiet \
    adduser=3.* \
    bc=1.* \
    ca-certificates=2024* \
    curl=8.* \
    debsums=3.* \
    init=1.* \
    jq=1.* \
    logrotate=3.* \
    netcat-traditional=1.* \
    ntpdate=1:4.* \
    rkhunter=1.* \
    sqlite3=3.* \
    sudo=1.* \
    wget=1.* && \
  apt-get clean all && \
  rm --recursive --force /var/lib/apt/lists/* && \
  userdel ubuntu && \
  addgroup --gid ${USER_AND_GROUP_ID} ${USERNAME} && \
  adduser \
    --uid ${USER_AND_GROUP_ID} ${USERNAME} \
    --ingroup ${USERNAME} \
    --disabled-password \
    --quiet && \
  usermod --append --groups sudo ${USERNAME} && \
  mkdir --parents ${ECNM_DATA_DIR} && \
  chown --recursive ${USERNAME} ${ECNM_DATA_DIR} && \
  mkdir --parents "${ENERGI_CORE_DIR}" ${NODEMON_LOG_DIR} && \
  touch ${NODEMON_LOG_DIR}/nodemon.log && \
  chown --recursive ${USERNAME}:${USERNAME} ${STAKER_HOME} && \
  touch ${LOG_DIR}/auth.log ${LOG_DIR}/kern.log
COPY --from=energi-builder [ "/go/energi/build/bin/energi3", "${ENERGI_BIN}" ]
COPY [ "etc", "/etc" ]
WORKDIR ${STAKER_HOME}
COPY --chown=${USERNAME}:${USERNAME} [ "scripts", "./" ]
USER ${USERNAME}
ENTRYPOINT [ "bash", "nodemon_cron.sh" ]
