#!/bin/bash
helm upgrade --install cardano-staking-testnet . -f values-testnet.yaml -n cardano-staking-testnet
