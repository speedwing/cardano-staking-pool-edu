#!/usr/bin/env bash

set -x

OS_ARCH=${OS_ARCH:-$(uname -m)}

if [[ $OS_ARCH == "arm64" ]];
then
  OS_ARCH=aarch64
fi

CARDANO_NODE_VERSION=1.30.1
CARDANO_NODE_IMAGE_TAG="${CARDANO_NODE_VERSION}-${OS_ARCH}"

docker build -t atada-scripts:"${CARDANO_NODE_IMAGE_TAG}" \
  --build-arg OS_ARCH="${OS_ARCH}" \
  --build-arg CARDANO_VERSION=${CARDANO_NODE_VERSION} \
  -f "atada-scripts.dockerfile" .
