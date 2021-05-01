#!/usr/bin/env bash

set -x

# Copying the atada script common config to user's home
cp testnet/.common.inc ~/

# Add scripts to path for ease of use
echo "Execute the line below so to have scripts in your path"
echo "export PATH=/home/cardano/scripts/cardano/testnet:$PATH"
