ARG CARDANO_VERSION="1.32.1"
ARG OS_ARCH

FROM speedwing/cardano-node:1.30.1-aarch64 as cardano-node

FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y jq libnuma-dev curl git netbase bc xxd vim && \
    rm -rf /var/lib/apt/lists/*

## Libsodium refs
COPY --from=cardano-node /usr/local/lib /usr/local/lib

## Not sure I still need thse
ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

COPY --from=cardano-node /etc/config/* /etc/config/

COPY --from=cardano-node /usr/local/bin/cardano-cli /usr/local/bin/cardano-cli
COPY --from=cardano-node /usr/local/bin/cardano-node /usr/local/bin/cardano-node

RUN useradd -ms /bin/bash cardano
USER cardano
WORKDIR /home/cardano

COPY atada /home/cardano/atada/
RUN id && pwd && ls -lart && git clone --depth 1 https://github.com/gitmachtl/scripts.git

ENTRYPOINT ["bash", "-c"]
