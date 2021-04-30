#!/usr/bin/env bash

OS_ARCH=$(uname -m)
CARDANO_NODE_VERSION=${CARDANO_NODE_VERSION:-1.26.2}

set -x

mkdir -p ~/tmp/cardano-cli || return 0

docker run -it --rm \
  -v "/home/ubuntu/tmp/cardano-cli:/tmp cardano-node:${CARDANO_NODE_VERSION}-${OS_ARCH}"
  "cp /usr/local/bin/cardano-cli /tmp/cardano-cli"

