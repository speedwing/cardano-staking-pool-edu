#!/usr/bin/env bash

set -x

OS_ARCH=$(uname -m)
NODE_VERSION="1.26.1"
IMAGE_TAG="${NODE_VERSION}-${OS_ARCH}"

## The folder, on the actual Raspberry Pi where to download the blockchain
DB_FOLDER=$1

## The port number of the Cardano Node to expose.
CARDANO_NODE_PORT=$2

NETWORK=${NETWORK:-mainnet}
NODE_MODE=${NODE_MODE:-relay}
KES_SKEY_PATH=${KES_SKEY_PATH:-/root/keys/pool-keys/kes.skey}
VRF_SKEY_PATH=${VRF_SKEY_PATH:-/root/keys/pool-keys/vrf.skey}
NODE_OP_CERT_PATH=${NODE_OP_CERT_PATH:-/root/keys/pool-keys-17-01-2021/node.cert}

if [[ -z "${DB_FOLDER}" ]]; then
  echo "Missing required DB_FOLDER, pass it as first param"
  exit 1
fi

if [[ -z "${CARDANO_NODE_PORT}" ]]; then
  echo "Missing required DB_FOLDER, pass it as second param"
  exit 1
fi

echo "Starting node with DB_FOLDER=$DB_FOLDER and CARDANO_NODE_PORT=$CARDANO_NODE_PORT"

if [ "${NODE_MODE}" = "relay" ]; then

  echo "Starting node in RELAY mode"

  sleep 5

  docker run --name "cardano-node-${NETWORK}" -d -v $DB_FOLDER:/db -e CARDANO_NODE_SOCKET_PATH=/db/node.socket "${@:3}" "cardano-node:${IMAGE_TAG}" \
    "cardano-node run \
    --topology /etc/config/${NETWORK}-topology.json \
    --database-path /db \
    --socket-path /db/node.socket \
    --host-addr 0.0.0.0 \
    --port $CARDANO_NODE_PORT \
    --config /etc/config/${NETWORK}-config.json"

elif [ "${NODE_MODE}" = "bp" ]; then

  echo "Starting node in BLOCK PRODUCER mode"

  sleep 5

  docker run --name "cardano-node-${NETWORK}" -d -v $DB_FOLDER:/db -e CARDANO_NODE_SOCKET_PATH=/db/node.socket "${@:3}" "cardano-node:${IMAGE_TAG}" \
    "cardano-node run \
    --topology /etc/config/${NETWORK}-topology.json \
    --database-path /db \
    --socket-path /db/node.socket \
    --host-addr 0.0.0.0 \
    --port $CARDANO_NODE_PORT \
    --config /etc/config/${NETWORK}-config.json \
    --shelley-kes-key ${KES_SKEY_PATH} \
    --shelley-vrf-key ${VRF_SKEY_PATH} \
    --shelley-operational-certificate ${NODE_OP_CERT_PATH}"

fi