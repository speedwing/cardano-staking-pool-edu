#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

docker build -t cardano-node:1.24.2 \
  -f 1.24.2.dockerfile . \
  --build-arg OS_ARCH="${OS_ARCH}"
