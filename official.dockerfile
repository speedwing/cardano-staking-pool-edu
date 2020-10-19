FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev \
    zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf llvm

# INSTALL GHC
# The Glasgow Haskell Compiler
ARG GHC_VERSION="8.6.5"
ARG OS_ARCH="aarch64"
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
ARG CABAL_VERSION="3.2.0.0"
WORKDIR /build/cabal
RUN wget -qO- https://github.com/haskell/cabal/archive/Cabal-v${CABAL_VERSION}.tar.gz | tar xzfv - -C . --strip-components 1 \
  && cd cabal-install \
  && ./bootstrap.sh \
  && cp ./dist/build/cabal/cabal /usr/local/bin