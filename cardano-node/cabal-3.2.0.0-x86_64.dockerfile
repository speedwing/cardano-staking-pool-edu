FROM ubuntu:18.04 as cabal

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev \
    zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf llvm

# INSTALL GHC
# The Glasgow Haskell Compiler
ARG GHC_VERSION="8.6.5"
ARG OS_ARCH
WORKDIR /build/ghc
RUN wget https://downloads.haskell.org/~ghc/${GHC_VERSION}/ghc-${GHC_VERSION}-${OS_ARCH}-deb9-linux.tar.xz
RUN tar -xf ghc-${GHC_VERSION}-${OS_ARCH}-deb9-linux.tar.xz
RUN cd ghc-${GHC_VERSION} && ./configure && make install

# INSTALL CABAL
# The Haskell Common Architecture for Building Applications and Libraries
ARG CABAL_VERSION="3.2.0.0"
WORKDIR /build/cabal
RUN wget -qO- https://github.com/haskell/cabal/archive/Cabal-v${CABAL_VERSION}.tar.gz | tar xzfv - -C . --strip-components 1 \
  && cd cabal-install \
  && ./bootstrap.sh

FROM ubuntu:18.04

COPY --from=cabal /root/.cabal/bin/cabal /usr/bin/
