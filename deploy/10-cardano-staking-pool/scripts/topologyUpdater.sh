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
  NWMAGIC="764824073"
else
  NWMAGIC="1097911063"
fi

NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

blockNo=$(curl -s cardano-relay-node-internal."${NAMESPACE}".svc.cluster.local:12798/metrics | grep cardano_node_ChainDB_metrics_blockNum_int | awk '{print $NF}')

if [ ! -z "${CNODE_HOSTNAME}" ]
then
  HOSTNAME_ARG="&hostname=${CNODE_HOSTNAME}"
fi

CURL_COMMAND="curl ${BASE_URL}/?port=${CNODE_PORT}&blockNo=${blockNo}${HOSTNAME_ARG}&valency=${CNODE_VALENCY}&magic=${NWMAGIC}"

echo "=> (${CURL_COMMAND})"

date

curl "${BASE_URL}/?port=${CNODE_PORT}&blockNo=${blockNo}${HOSTNAME_ARG}&valency=${CNODE_VALENCY}&magic=${NWMAGIC}"
curl "${CNODE_TOPOLOGY}".tmp "https://api.clio.one/htopology/v1/fetch/?max=${MAX_PEERS}&magic=${NWMAGIC}"
