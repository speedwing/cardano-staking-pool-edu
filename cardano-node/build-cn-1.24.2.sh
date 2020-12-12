#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

docker build -t cardano-node:1.24.2 \
  --build-arg GHC_VERSION=8.10.2 \
  --build-arg OS_ARCH="${OS_ARCH}" \
  --build-arg CARDANO_VERSION=1.24.2 \
  -f 1.24.2.dockerfile .
