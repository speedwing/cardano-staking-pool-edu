#!/bin/bash
helm upgrade --install cardano-staking-mainnet . -f values-mainnet.yaml -n cardano-staking-mainnet
