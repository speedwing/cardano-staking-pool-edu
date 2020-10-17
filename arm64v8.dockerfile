FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1


FROM arm64v8/ubuntu:focal

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y libsodium-dev build-essential \
    pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ \
    tmux git jq wget libncursesw5 llvm cabal-install

## Cabal update
RUN cabal -V && sleep 10
#RUN cabal install Cabal
#RUN cabal -V

#ENV PATH="/root/.cabal/bin:${PATH}"

#RUN cabal -V

## This seems to have worked
#RUN wget https://downloads.haskell.org/ghc/8.6.5/ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
#RUN tar -xf ghc-8.6.5-aarch64-ubuntu18.04-linux.tar.xz
#RUN cd ghc-8.6.5/ && ./configure && make install

