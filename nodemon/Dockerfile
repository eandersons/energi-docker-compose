# Build the binary `energi3` in a stock Go builder container
FROM golang:1.15-buster as energi3-builder

RUN apt-get update\
 && apt-get install --assume-yes --no-install-recommends --quiet musl-dev\
 && apt-get clean;\
 git clone --branch v3.1.0 --depth 1\
  https://github.com/energicryptocurrency/energi3.git energi3\
 && cd energi3 && make geth


# `ubuntu:latest` means "The latest Ubuntu LTS release"
# https://hub.docker.com/_/ubuntu
FROM ubuntu:latest

ARG ECNM_DATA_DIR=/var/multi-masternode-data/nodebot
ARG USER_AND_GROUP_ID=1000
ARG USERNAME=nrgstaker
ARG USER_HOME=/home/${USERNAME}
ARG NODEMON_LOG_DIR=${USER_HOME}/log

RUN DEBIAN_FRONTEND=noninteractive\
 apt-get update --quiet && apt-get upgrade --assume-yes --quiet &&\
 apt-get install --assume-yes --no-install-recommends --quiet\
  bc ca-certificates curl debsums init jq logrotate ntpdate rkhunter sqlite3\
  sudo wget;\
 apt-get clean all && rm --recursive --force /var/lib/apt/lists/*;\
 addgroup --gid ${USER_AND_GROUP_ID} ${USERNAME} &&\
 adduser\
  --uid ${USER_AND_GROUP_ID} ${USERNAME}\
  --ingroup ${USERNAME}\
  --disabled-password\
  --quiet;\
 usermod --append --groups sudo ${USERNAME};\
 mkdir --parents ${ECNM_DATA_DIR} &&\
 chown --recursive ${USERNAME} ${ECNM_DATA_DIR};\
 mkdir --parents ${NODEMON_LOG_DIR} && touch ${NODEMON_LOG_DIR}/nodemon.log &&\
 chown --recursive ${USERNAME}:${USERNAME} ${NODEMON_LOG_DIR};\
 touch /var/log/auth.log; touch /var/log/kern.log

COPY --from=energi3-builder [ "/go/energi3/build/bin/energi3", "/usr/local/bin/" ]
RUN [ "chmod", "+x", "/usr/local/bin/energi3" ]

COPY [ "etc", "/etc" ]

WORKDIR ${USER_HOME}

COPY --chown=${USERNAME}:${USERNAME} [ "scripts/*", "./" ]

USER ${USERNAME}

ENTRYPOINT [ "bash", "nodemon_cron.sh" ]
