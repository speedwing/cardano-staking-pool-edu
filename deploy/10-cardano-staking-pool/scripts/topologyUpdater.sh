#!/usr/bin/env bash

set -x

if [ -z "${NETWORK}" ]; then
  echo "Missing required NETWORK env var. Exiting..."
  exit 1
fi

if [ -z "${BASE_URL}" ]; then
  echo "Missing required BASE_URL env var. Exiting..."
  exit 1
fi

if [ -z "${CNODE_HOSTNAME}" ]; then
  echo "Missing required CNODE_HOSTNAME env var. Exiting..."
  exit 1
fi

if [ -z "${CNODE_PORT}" ]; then
  echo "Missing required CNODE_PORT env var. Exiting..."
  exit 1
fi

CNODE_VALENCY=1

if [ "${NETWORK}" = "mainnet" ]; then
  TESTNET_MAGIC="764824073"
else
  TESTNET_MAGIC="1097911063"
fi

NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

blockNo=$(curl -s cardano-relay-node-internal."${NAMESPACE}".svc.cluster.local:13788/metrics | grep cardano_node_ChainDB_metrics_blockNum_int | awk '{print $NF}')

if [ ! -z "${CNODE_HOSTNAME}" ]
then
  HOSTNAME_ARG="&hostname=${CNODE_HOSTNAME}"
fi

CURL_COMMAND="curl -s ${BASE_URL}/?port=${CNODE_PORT}&blockNo=${blockNo}${HOSTNAME_ARG}&valency=${CNODE_VALENCY}&magic=${TESTNET_MAGIC}"

echo "=> (${CURL_COMMAND})"

#curl -s "${BASE_URL}/?port=${CNODE_PORT}&blockNo=${blockNo}${HOSTNAME_ARG}&valency=${CNODE_VALENCY}&magic=${TESTNET_MAGIC}"