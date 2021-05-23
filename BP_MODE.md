# Run in Block Producing (BP) Mode

Finally, we made it to the last step of this tutorial. I assume you've got the blockchain downloaded by now,
and you've also got all the keys and certificates required to run your block producing node.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Running the node in BP mode.

> Just a reminder that this tutorial will focus on how to create a Block Producing node (BP) on **testnet**

Starting the node in bp mode for testnet should be as easy as:

```bash
docker stop cardano-node-testnet

cd ~/cardano-staking-pool-edu && git pull --rebase # Ensure we're on the latest version of the project

cd ~/cardano-staking-pool-edu/cardano-node && \
  NODE_MODE=bp \
  NETWORK=testnet \
  KES_SKEY_PATH=/home/ubuntu/.keys/testnet/africa.kes-000.skey \
  VRF_SKEY_PATH=/home/ubuntu/.keys/testnet/africa.vrf.skey \
  NODE_OP_CERT_PATH=/home/ubuntu/.keys/testnet/africa.node-000.opcert \
  ./run-node.sh /home/ubuntu/cardano-node/testnet 30001 --restart unless-stopped
```

