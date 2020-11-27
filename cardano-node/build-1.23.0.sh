#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

docker build -t speedwing/cardano-node:1.23.0 \
  -f 1.23.0.dockerfile . \
  --build-arg OS_ARCH="${OS_ARCH}"
