#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

# This is required for MBP M1, the kernel reports arm64 instead of aarch64, despite the
# to being the same
if [[ "$OS_ARCH" = "arm64" ]];
then
  OS_ARCH="aarch64"
fi
MEMORY=${MEMORY:-7}

CARDANO_NODE_VERSION=1.29.0
CARDANO_NODE_IMAGE_TAG="${CARDANO_NODE_VERSION}-${OS_ARCH}"

docker build -m "${MEMORY}Gi" --memory-swap -1 -t cardano-node:"${CARDANO_NODE_IMAGE_TAG}" \
  --build-arg GHC_VERSION=8.10.2 \
  --build-arg OS_ARCH="${OS_ARCH}" \
  --build-arg CARDANO_VERSION=${CARDANO_NODE_VERSION} \
  -f "${CARDANO_NODE_VERSION}-${OS_ARCH}.dockerfile" . \
  2>&1 \
  | tee /tmp/cardano-node-build.logs
