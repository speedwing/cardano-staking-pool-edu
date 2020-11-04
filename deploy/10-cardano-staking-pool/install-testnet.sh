#!/bin/bash
helm upgrade --install cardano-staking-mainnet . -f values-testnet.yaml -n cardano-staking-testnet
