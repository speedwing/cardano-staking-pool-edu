#!/usr/bin/env bash

set -x

OS_ARCH=${OS_ARCH:-`uname -m`}

CARDANO_NODE_VERSION=1.29.0
CARDANO_NODE_IMAGE_TAG="${CARDANO_NODE_VERSION}-${OS_ARCH}"

docker build -t atada-scripts:"${CARDANO_NODE_IMAGE_TAG}" \
  --build-arg OS_ARCH="${OS_ARCH}" \
  --build-arg CARDANO_VERSION=${CARDANO_NODE_VERSION} \
  -f "atada-scripts.dockerfile" .
