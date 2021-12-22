#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)

if [[ $OS_ARCH == "arm64" ]];
then
  OS_ARCH=aarch65
fi

NODE_VERSION="1.30.1"
IMAGE_TAG="${NODE_VERSION}-${OS_ARCH}"

# Network
NETWORK=${NETWORK:-testnet}

## The folder, on the actual Raspberry Pi where to download the blockchain
DB_FOLDER=${DB_FOLDER:-/home/ubuntu/cardano-node/$NETWORK}

# Keys Folder
KEYS_FOLDER=${KEYS_FOLDER:-/home/ubuntu/.keys/$NETWORK}

docker run -it --rm \
    -v "$KEYS_FOLDER:/home/cardano/keys" \
    -v "$DB_FOLDER:/home/ubuntu/cardano-node/" \
    "atada-scripts:${NODE_VERSION}-${OS_ARCH}" bash
