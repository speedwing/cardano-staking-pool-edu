FROM arm64v8/ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ARG NODE_VERSION="1.13.0-rewards"
ARG USER_NAME="cardano-node"
ARG USER_ID="256"
ARG GROUP_NAME="cardano-node"
ARG GROUP_ID="256"
ARG CABAL_VERSION="3.2.0.0"
ARG GHC_VERSION="8.6.5"
ARG OS_ARCH="aarch64"

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y libsodium-dev build-essential \
    pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ \
    tmux git jq wget libncursesw5 xz-utils llvm

# INSTALL GHC
# The Glasgow Haskell Compiler
WORKDIR /build/ghc
RUN wget -qO-  https://downloads.haskell.org/ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-${OS_ARCH}-ubuntu18.04-linux.tar.xz | tar xJf - -C . --strip-components 1 \
 && ./configure \
 && make install

# INSTALL CABAL
# The Haskell Common Architecture for Building Applications and Libraries
WORKDIR /build/cabal
RUN wget -qO- https://github.com/haskell/cabal/archive/Cabal-v${CABAL_VERSION}.tar.gz | tar xzfv - -C . --strip-components 1 \
  && cd cabal-install \
  && ./bootstrap.sh \
  && cp ./dist/build/cabal/cabal /usr/local/bin
