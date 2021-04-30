FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev \
    zlib1g-dev make g++ tmux git jq curl libncursesw5 libtool autoconf llvm libnuma-dev

# INSTALL GHC
# The Glasgow Haskell Compiler
ARG GHC_VERSION="8.10.2"
ARG OS_ARCH
WORKDIR /build/ghc
RUN curl https://downloads.haskell.org/~ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-${OS_ARCH}-deb10-linux.tar.xz | \
    tar -Jx -C /build/ghc
RUN cd ghc-${GHC_VERSION} && ./configure && make install

# Install Libsodium
WORKDIR /build/libsodium
RUN git clone https://github.com/input-output-hk/libsodium
RUN cd libsodium && \
    git checkout 66f017f1 && \
    ./autogen.sh && ./configure && make && make install

ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

# Cabal to PATH
RUN curl -L https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-${OS_ARCH}-ubuntu-16.04.tar.xz | \
    tar -Jx -C /usr/bin/
RUN cabal update

ARG CARDANO_VERSION="1.26.2"
WORKDIR /build/cardano-node
RUN git clone --branch ${CARDANO_VERSION} https://github.com/input-output-hk/cardano-node.git && \
    cd cardano-node && \
    cabal configure --with-compiler=ghc-8.10.2 && \
    cabal build all

FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends netbase jq libnuma-dev curl && \
    rm -rf /var/lib/apt/lists/*

## Libsodium refs
COPY --from=builder /usr/local/lib /usr/local/lib

ARG OS_ARCH
ARG GHC_VERSION
ARG CARDANO_VERSION

## Not sure I still need thse
ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

RUN rm -fr /usr/local/lib/ghc-${GHC_VERSION}

COPY config/mainnet /etc/config
COPY config/testnet /etc/config

COPY --from=builder /build/cardano-node/cardano-node/dist-newstyle/build/${OS_ARCH}-linux/ghc-${GHC_VERSION}/cardano-node-${CARDANO_VERSION}/x/cardano-node/build/cardano-node/cardano-node /usr/local/bin/
COPY --from=builder /build/cardano-node/cardano-node/dist-newstyle/build/${OS_ARCH}-linux/ghc-${GHC_VERSION}/cardano-cli-${CARDANO_VERSION}/x/cardano-cli/build/cardano-cli/cardano-cli /usr/local/bin/

## Attempt to check on the prometheus metrics port if the node is up and running
HEALTHCHECK --interval=10s --timeout=60s --start-period=300s --retries=3 CMD curl -f http://localhost:12798/metrics || exit 1

RUN useradd -ms /bin/bash cardano
USER cardano
WORKDIR /home/cardano

ENTRYPOINT ["bash", "-c"]
