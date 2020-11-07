#!/usr/bin/env bash

if [[ -z "${CARDANO_POOL_ID}" ]]; then
  echo "The required CARDANO_POOL_ID env var is not set. Exiting..."
  exit 1
fi

if [[ -z "${POOL_TOOL_API_KEY}" ]]; then
  echo "The required POOL_TOOL_API_KEY env var is not set. Exiting..."
  exit 1
fi

if [[ -z "${NODE_VERSION}" ]]; then
  echo "The required POOL_TOOL_API_KEY env var is not set. Exiting..."
  exit 1
fi

# your pool id as on the explorer
PT_MY_POOL_ID=${CARDANO_POOL_ID}
# get this from your account profile page on pooltool website
PT_MY_API_KEY=${POOL_TOOL_API_KEY}
# Your node ID (optional, this is reserved for future use and is not captured yet)
PT_MY_NODE_ID="xxxx-xxx-xxx-xxx-xxxx"
# THE NAME OF THE SCRIPT YOU USE TO MANAGE YOUR POOL

echo "NODE_VERSION => ${NODE_VERSION}"
echo "PT_MY_POOL_ID => ${PT_MY_POOL_ID}"
echo "PT_MY_API_KEY => ${PT_MY_API_KEY}"

shopt -s expand_aliases

alias cli="$(which cardano-cli) shelley"

while true ; do
  sleep 1
  nodeTip=$(cli query tip --testnet-magic 1097911063)
  lastSlot=$(echo ${nodeTip} | jq -r .slotNo)
  lastBlockHash=$(echo ${nodeTip} | jq -r .headerHash)
  lastBlockHeight=$(echo ${nodeTip} | jq -r .blockNo)

  JSON="$(jq -n --compact-output --arg NODE_ID "$PT_MY_NODE_ID" --arg MY_API_KEY "$PT_MY_API_KEY" --arg MY_POOL_ID "$PT_MY_POOL_ID" --arg VERSION "$NODE_VERSION" --arg BLOCKNO "$lastBlockHeight" --arg SLOTNO "$lastSlot" --arg BLOCKHASH "$lastBlockHash" '{apiKey: $MY_API_KEY, poolId: $MY_POOL_ID, data: {nodeId: $NODE_ID, version: $VERSION, blockNo: $BLOCKNO, slotNo: $SLOTNO, blockHash: $BLOCKHASH}}')"
  echo "Packet Sent: $JSON"

  if [ "${lastBlockHeight}" != "" ]; then
  RESPONSE="$(curl -s -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "$JSON" "https://api.pooltool.io/v0/sendstats")"
  echo $RESPONSE
  fi
done