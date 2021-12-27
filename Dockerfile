ARG ENERGI_VERSION

FROM energicryptocurrency/energi:${ENERGI_VERSION}

ARG USER_AND_GROUP_ID=1000
ARG USERNAME=nrgstaker
ARG STAKER_HOME

ENV SSHD_DIR=${STAKER_HOME}/.sshd

WORKDIR ${STAKER_HOME}/energi3

RUN addgroup --gid ${USER_AND_GROUP_ID} ${USERNAME} \
  && adduser \
  --uid ${USER_AND_GROUP_ID} ${USERNAME} \
  --ingroup ${USERNAME} \
  --disabled-password; \
  apk --no-cache add curl openssh-server-pam procps; \
  mkdir -p ${SSHD_DIR} \
  && ssh-keygen -f ${SSHD_DIR}/host_rsa_key -N '' -t rsa \
  && ssh-keygen -f ${SSHD_DIR}/host_dsa_key -N '' -t dsa; \
  mkdir ${STAKER_HOME}/.energicore3; \
  chown -R ${USERNAME}:${USERNAME} ${STAKER_HOME}

COPY --chown=${USERNAME}:${USERNAME} [ ".sshd", "${SSHD_DIR}/" ]
COPY --chown=${USERNAME}:${USERNAME} [ "scripts", "./" ]

USER ${USERNAME}

ENTRYPOINT ["/bin/sh", "energi3-core-run.sh"]
