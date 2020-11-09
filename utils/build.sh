#!/usr/bin/env bash

VERSION=0.1

GIT_COMMIT_SHA=$(git describe --always)

TAG="${VERSION}-${GIT_COMMIT_SHA}"

if [ "$1" = "arm64" ]; then
  docker buildx build --push -t speedwing/cardano-node-utils:"${TAG}" .
else
  docker build -t speedwing/cardano-node-utils:"${TAG}" .
  docker push -t speedwing/cardano-node-utils:"${TAG}"
fi
