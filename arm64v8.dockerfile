FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1


FROM arm64v8/ubuntu:20.04

# Add QEMU
COPY --from=builder qemu-aarch64-static /usr/bin

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y libsodium-dev build-essential \
    pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ \
    tmux git jq wget libncursesw5 llvm

RUN apt-get install -y cabal-install ghc

ARG CARDANO_NODE_COMMIT=1.21.1
ENV CARDANO_NODE_COMMIT ${CARDANO_NODE_COMMIT}

RUN git clone https://github.com/input-output-hk/cardano-node.git && \
    cd cardano-node && \
    git checkout ${CARDANO_NODE_COMMIT} && \
    cabal update && \
    for target in cardano-node cardano-cli; do cabal new-build ${target}; done

