FROM ubuntu:18.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev \
    zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf llvm

# INSTALL GHC
# The Glasgow Haskell Compiler
ENV GHC_VERSION="8.6.5"
ENV OS_ARCH="aarch64"
WORKDIR /build/ghc
RUN wget https://downloads.haskell.org/~ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-${OS_ARCH}-ubuntu18.04-linux.tar.xz
RUN tar -xf ghc-${GHC_VERSION}-${OS_ARCH}-ubuntu18.04-linux.tar.xz
RUN cd ghc-${GHC_VERSION} && ./configure && make install

# Install Libsodium
WORKDIR /build/libsodium
RUN git clone https://github.com/input-output-hk/libsodium
RUN cd libsodium && \
    git checkout 66f017f1 && \
    ./autogen.sh && ./configure && make && make install

ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

# INSTALL CABAL
# The Haskell Common Architecture for Building Applications and Libraries
ENV CABAL_VERSION="3.2.0.0"
WORKDIR /build/cabal
RUN wget -qO- https://github.com/haskell/cabal/archive/Cabal-v${CABAL_VERSION}.tar.gz | tar xzfv - -C . --strip-components 1 \
  && cd cabal-install \
  && ./bootstrap.sh

# Cabal to PATH
ENV PATH="/root/.cabal/bin:${PATH}"

ENV CARDANO_VERSION="1.21.1"
WORKDIR /build/cardano-node
RUN git clone --branch ${CARDANO_VERSION} https://github.com/input-output-hk/cardano-node.git && \
    cd cardano-node && \
    cabal update && \
    cabal build all

FROM ubuntu:18.04

## Libsodium refs
COPY --from=builder /usr/local/lib /usr/local/lib

## Not sure I still need thse
ENV LD_LIBRARY_PATH="/usr/local/lib"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

RUN rm -fr /usr/local/lib/ghc-8.6.5

COPY --from=builder /build/cardano-node/cardano-node/dist-newstyle/build/${OS_ARCH}-linux/ghc-${GHC_VERSION}/cardano-node-${CARDANO_VERSION}/x/cardano-node/build/cardano-node/cardano-node /usr/local/bin/
COPY --from=builder /build/cardano-node/cardano-node/dist-newstyle/build/${OS_ARCH}-linux/ghc-${GHC_VERSION}/cardano-cli-${CARDANO_VERSION}/x/cardano-cli/build/cardano-cli/cardano-cli /usr/local/bin/

ENTRYPOINT ["bash", "-c"]