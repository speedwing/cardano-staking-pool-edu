#!/usr/bin/env bash

NETWORK=testnet
CARDANO_NODE_PORT=3001

./run-node.sh /home/ubuntu/cardano-node/testnet "${CARDANO_NODE_PORT}" --restart unless-stopped
