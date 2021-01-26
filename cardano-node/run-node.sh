#!/usr/bin/env bash

set -x

DB_FOLDER=$1
CARDANO_NODE_PORT=$2

if [[ -z "${DB_FOLDER}" ]]; then
  echo "Missing required DB_FOLDER, pass it as first param"
  exit 1
fi

if [[ -z "${CARDANO_NODE_PORT}" ]]; then
  echo "Missing required DB_FOLDER, pass it as first param"
  exit 1
fi

echo "Starting node with DB_FOLDER=$DB_FOLDER and CARDANO_NODE_PORT=$CARDANO_NODE_PORT"

docker run --name cardano-node -d --rm -v $DB_FOLDER:/db -e CARDANO_NODE_SOCKET_PATH=/db/node.socket "${@:3}" cardano-node:1.24.2 \
  "cardano-node run \
  --topology /etc/config/mainnet-topology.json \
  --database-path /db \
  --socket-path /db/node.socket \
  --host-addr 0.0.0.0 \
  --port $CARDANO_NODE_PORT \
  --config /etc/config/mainnet-config.json"
