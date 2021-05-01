#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)
NODE_VERSION="1.26.2"
IMAGE_TAG="${NODE_VERSION}-${OS_ARCH}"

# Network
NETWORK=${NETWORK:-testnet}

## The folder, on the actual Raspberry Pi where to download the blockchain
DB_FOLDER=${DB_FOLDER:-/home/ubuntu/cardano-node/$NETWORK}

# Keys Folder
KEYS_FOLDER=/home/ubuntu/.keys/$NETWORK

docker run -it --rm \
    -v $KEYS_FOLDER:/home/cardano/keys \
    "atada-scripts:${NODE_VERSION}-${OS_ARCH}" bash
