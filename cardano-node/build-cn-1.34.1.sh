#!/usr/bin/env bash

. dl-config.sh

set -x

(download_config)

OS_ARCH=$(uname -m)

CARDANO_NODE_VERSION=1.34.1

if [[ $OS_ARCH == "arm64" || $OS_ARCH == "aarch64" ]];
then
  echo "Detected, ${OS_ARCH}"
  OS_ARCH="aarch64"
  CARDANO_NODE_IMAGE_TAG="${CARDANO_NODE_VERSION}-${OS_ARCH}"
  docker build -t cardano-node:"${CARDANO_NODE_IMAGE_TAG}" \
    -f "${CARDANO_NODE_VERSION}-${OS_ARCH}.dockerfile" .
else
  echo "Detected, ${OS_ARCH}, using buildx"
  OS_ARCH="aarch64"
  CARDANO_NODE_IMAGE_TAG="${CARDANO_NODE_VERSION}-${OS_ARCH}"
  docker buildx use aarch64
  docker buildx build --load -t cardano-node:"${CARDANO_NODE_IMAGE_TAG}" \
    --build-arg GHC_VERSION=8.10.2 \
    --build-arg OS_ARCH="${OS_ARCH}" \
    --build-arg CARDANO_VERSION=${CARDANO_NODE_VERSION} \
    -f "${CARDANO_NODE_VERSION}-${OS_ARCH}.dockerfile" . \
    2>&1 \
    | tee /tmp/cardano-node-build.logs
fi

(rm_config_folder)
