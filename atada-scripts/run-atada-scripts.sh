#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)
NODE_VERSION="1.26.2"
IMAGE_TAG="${NODE_VERSION}-${OS_ARCH}"

# Network
NETWORK=${NETWORK:-testnet}

## The folder, on the actual Raspberry Pi where to download the blockchain
DB_FOLDER=${DB_FOLDER:-/home/ubuntu/cardano-node/$NETWORK}

docker run -it --rm "atada-script:${NODE_VERSION}-${OS_ARCH}" bash
