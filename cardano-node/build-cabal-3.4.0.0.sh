#!/usr/bin/env bash

set -x

CABAL_VERSION=3.4.0.0
OS_ARCH=$(uname -m)

if [[ "${OS_ARCH}" = "aarch64" ]]; then
  DOCKERFILE="cabal-${CABAL_VERSION}-aarch64.dockerfile"
elif [[ "${OS_ARCH}" = "x86_64" ]]; then
  DOCKERFILE="cabal-${CABAL_VERSION}-x86_64.dockerfile"
else
  echo "Unknown platform ${OS_ARCH}... exiting"
  exit 1
fi

docker build -t "cabal:${CABAL_VERSION}-${OS_ARCH}" \
  -f ${DOCKERFILE} . \
  --build-arg OS_ARCH="${OS_ARCH}"
