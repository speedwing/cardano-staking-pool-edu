#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

CARDANO_NODE_VERSION=1.25.1

docker build -t cardano-node:"${CARDANO_NODE_VERSION}-${OS_ARCH}" \
  --build-arg GHC_VERSION=8.10.2 \
  --build-arg OS_ARCH="${OS_ARCH}" \
  --build-arg CARDANO_VERSION=${CARDANO_NODE_VERSION} \
  -f ${CARDANO_NODE_VERSION}.dockerfile .
