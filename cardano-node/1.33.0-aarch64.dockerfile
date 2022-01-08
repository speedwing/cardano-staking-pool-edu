FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y curl zip

WORKDIR /cardano-node
RUN curl -LO https://ci.zw3rk.com/build/427926/download/1/aarch64-unknown-linux-musl-cardano-node-1.33.0.zip && \
    unzip aarch64-unknown-linux-musl-cardano-node-1.33.0.zip

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y curl zip netbase jq libnuma-dev && \
    rm -rf /var/lib/apt/lists/*

COPY config /etc/config

COPY --from=builder /cardano-node/cardano-node/cardano-node /usr/local/bin/
COPY --from=builder /cardano-node/cardano-node/cardano-cli /usr/local/bin/

## Attempt to check on the prometheus metrics port if the node is up and running
HEALTHCHECK --interval=10s --timeout=60s --start-period=300s --retries=3 CMD curl -f http://localhost:12798/metrics || exit 1

RUN useradd -ms /bin/bash cardano
USER cardano
WORKDIR /home/cardano

ENTRYPOINT ["bash", "-c"]
