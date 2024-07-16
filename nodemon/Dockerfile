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


# `ubuntu:latest` means "The latest Ubuntu LTS release"
# https://hub.docker.com/_/ubuntu
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
    adduser=3.137ubuntu1 \
    bc=1.07.1-3ubuntu4 \
    ca-certificates=20240203 \
    curl=8.5.0-2ubuntu10.1 \
    debsums=3.0.2.1 \
    init=1.66ubuntu1 \
    jq=1.7.1-3build1 \
    logrotate=3.21.0-2build1 \
    netcat-traditional=1.10-48 \
    ntpdate=1:4.2.8p15+dfsg-2~1.2.2+dfsg1-4build2 \
    rkhunter=1.4.6-12 \
    sqlite3=3.45.1-1ubuntu2 \
    sudo=1.9.15p5-3ubuntu5 \
    wget=1.21.4-1ubuntu4.1 && \
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
