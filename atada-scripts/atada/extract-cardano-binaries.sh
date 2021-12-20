#!/usr/bin/env bash

OS_ARCH=$(uname -m)
CARDANO_NODE_VERSION=${CARDANO_NODE_VERSION:-1.32.1}

set -x

mkdir -p ~/tmp/cardano-bin || return 0

docker run -it --rm \
  -v /home/ubuntu/tmp/cardano-bin:/tmp "cardano-node:${CARDANO_NODE_VERSION}-${OS_ARCH}" \
  "cp /usr/local/bin/cardano-cli /tmp/; cp /usr/local/bin/cardano-node /tmp/"

sudo cp ~/tmp/cardano-bin/cardano-cli /usr/local/bin/
sudo cp ~/tmp/cardano-bin/cardano-node /usr/local/bin/
