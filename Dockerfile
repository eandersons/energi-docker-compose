FROM energicryptocurrency/energi3:v3.0.7

RUN apk --no-cache add curl

RUN ["mkdir", "/root/energi3"]

WORKDIR /root/energi3

COPY --chown=root:root ["scripts", "./"]

ENTRYPOINT ["/bin/sh", "energi3-core-run.sh"]
