#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

CARDANO_NODE_VERSION=1.26.0

CARDANO_NODE_IMAGE_TAG="${CARDANO_NODE_VERSION}-${OS_ARCH}"

docker build -m 7Gi --memory-swap -1 -t cardano-node:"${CARDANO_NODE_IMAGE_TAG}" \
  --build-arg GHC_VERSION=8.10.2 \
  --build-arg OS_ARCH="${OS_ARCH}" \
  --build-arg CARDANO_VERSION=${CARDANO_NODE_VERSION} \
  -f "${CARDANO_NODE_VERSION}-${OS_ARCH}.dockerfile" . \
  | tee /tmp/cardano-node-build.logs
