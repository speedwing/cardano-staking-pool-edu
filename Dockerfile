FROM arm64v8/ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y libsodium-dev build-essential \
    pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ \
    tmux git jq wget libncursesw5 xz-utils llvm

# INSTALL GHC
# The Glasgow Haskell Compiler
ARG GHC_VERSION="8.6.5"
ARG OS_ARCH="aarch64"
WORKDIR /build/ghc
RUN wget -qO-  https://downloads.haskell.org/ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-${OS_ARCH}-ubuntu18.04-linux.tar.xz | tar xJf - -C . --strip-components 1 \
    && ./configure \
    && make install

# INSTALL CABAL
# The Haskell Common Architecture for Building Applications and Libraries
ARG CABAL_VERSION="3.2.0.0"
WORKDIR /build/cabal
RUN wget -qO- https://github.com/haskell/cabal/archive/Cabal-v${CABAL_VERSION}.tar.gz | tar xzfv - -C . --strip-components 1 \
  && cd cabal-install \
  && ./bootstrap.sh \
  && cp ./dist/build/cabal/cabal /usr/local/bin

# DOWNLOAD AND PREPARE CARDANO SOURCE CODE
ARG NODE_VERSION="1.21.1"
WORKDIR /build/cardano
RUN git clone https://github.com/input-output-hk/cardano-node.git . \
 && git fetch --all --tags \
 && tag=$([ "${NODE_VERSION}" = "latest" ] && echo $(git describe --tags $(git rev-list --tags --max-count=1)) || echo ${NODE_VERSION}) \
 && git checkout tags/${tag} \
 && cabal update

# BUILD CARDANO-NODE AND CARDANO-CLI
RUN echo -e "package cardano-crypto-praos\n  flags: -external-libsodium-vrf" > cabal.project.local \
    && cabal build all
