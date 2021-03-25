#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

if [[ "${OS_ARCH}" = "aarch64" ]]; then
  DOCKERFILE="cabal-3.2.0.0-aarch64.dockerfile"
elif [[ "${OS_ARCH}" = "x86_64" ]]; then
  DOCKERFILE="cabal-3.2.0.0-x86_64.dockerfile"
else
  echo "Unknown platform ${OS_ARCH}... exiting"
  exit 1
fi

docker build -t cabal:3.2.0.0-${OS_ARCH} \
  -f ${DOCKERFILE} . \
  --build-arg OS_ARCH="${OS_ARCH}"
