#!/bin/bash
helm upgrade --install cardano-experiment . -f values-testnet-experiment.yaml -n cardano-experiment
