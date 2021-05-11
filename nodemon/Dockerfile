# `ubuntu:latest` means "the latest Ubuntu LTS release"
# https://hub.docker.com/_/ubuntu
FROM ubuntu:latest

ENV ECNM_DATA_DIR=/var/multi-masternode-data/nodebot
ENV USER_AND_GROUP_ID=1000
ENV USERNAME=nrgstaker
ENV USER_HOME=/home/${USERNAME}
ENV NODEMON_LOG_DIR=${USER_HOME}/logs

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

COPY [ "bin/energi3", "/usr/local/bin/" ]
RUN [ "chmod", "+x", "/usr/local/bin/energi3" ]

COPY [ "etc", "/etc" ]

WORKDIR ${USER_HOME}

COPY --chown=${USERNAME}:${USERNAME} [ "scripts/*", "./" ]

USER ${USERNAME}

ENTRYPOINT [ "bash", "nodemon_cron.sh" ]
