ARG ENERGI_VERSION

FROM energicryptocurrency/energi3:${ENERGI_VERSION}

ARG USER_AND_GROUP_ID=1000
ARG USERNAME=nrgstaker
ARG STAKER_HOME

WORKDIR ${STAKER_HOME}/energi3

RUN addgroup --gid ${USER_AND_GROUP_ID} ${USERNAME} \
  && adduser \
  --uid ${USER_AND_GROUP_ID} ${USERNAME} \
  --ingroup ${USERNAME} \
  --disabled-password && \
  mkdir ${STAKER_HOME}/.energicore3 \
  && chown -R ${USERNAME}:${USERNAME} ${STAKER_HOME}; \
  apk --no-cache add curl

COPY --chown=${USERNAME}:${USERNAME} [ "scripts", "./" ]

USER ${USERNAME}

ENTRYPOINT ["/bin/sh", "energi3-core-run.sh"]
