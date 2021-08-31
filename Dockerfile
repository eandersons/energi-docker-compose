ARG ENERGI_VERSION

FROM energicryptocurrency/energi3:${ENERGI_VERSION}

ENV USER_AND_GROUP_ID=1000
ENV USERNAME=nrgstaker
ENV NRGSTAKER_HOME=/home/${USERNAME}

WORKDIR ${NRGSTAKER_HOME}/energi3

RUN addgroup --gid ${USER_AND_GROUP_ID} ${USERNAME} && \
    adduser \
    --uid ${USER_AND_GROUP_ID} ${USERNAME} \
    --ingroup ${USERNAME} \
    --disabled-password && \
    chown -R ${USERNAME}:${USERNAME} ${NRGSTAKER_HOME}; \
    apk --no-cache add curl

COPY --chown=${USERNAME}:${USERNAME} ["scripts", "./"]

USER ${USERNAME}

ENTRYPOINT ["/bin/sh", "energi3-core-run.sh"]
