#!/usr/bin/env bash

export NETWORK=testnet

docker rm cardano-node-testnet || true
docker run --name cardano-node-testnet -d -v ~/cardano-node/testnet:/data/db -e NETWORK=testnet cardano-node:1.35.2-x86_64
