FROM energicryptocurrency/energi3:v3.0.6

RUN ["mkdir", "/root/energi3"]

WORKDIR /root/energi3

COPY --chown=root:root ["energi3-core-run.sh", "./"]

RUN ["chmod", "+x", "energi3-core-run.sh"]

ENTRYPOINT ["./energi3-core-run.sh"]
