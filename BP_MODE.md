# Run in Block Producing (BP) Mode

Finally, we made it to the last step of this tutorial. I assume you've got the blockchain downloaded by now,
and you've also got all the keys and certificates required to run your block producing node.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Running the node in BP mode.

> Just a reminder that this tutorial will focus on how to create a Block Producing node (BP) on **testnet**

> Please ensure to change the `CARDANO_NODE_PORT` parameter below, with the one you've setup on your router
> to redirect connections from the router to the pi.

Starting the node in bp mode for testnet should be as easy as:

```bash
cd ~/cardano-staking-pool-edu && git pull --rebase # Ensure we're on the latest version of the project

docker stop cardano-node-testnet
docker rm cardano-node-testnet
cd ~/cardano-staking-pool-edu/cardano-node && \
  NODE_MODE=bp \
  NETWORK=testnet \
  KES_SKEY_PATH=/home/cardano/keys/joe1.kes-005.skey \
  VRF_SKEY_PATH=/home/cardano/keys/joe1.vrf.skey \
  NODE_OP_CERT_PATH=/home/cardano/keys/joe1.node-005.opcert \
  ./run-node.sh /home/ubuntu/cardano-node/testnet 30000 --restart unless-stopped \
  -v /home/ubuntu/.keys/testnet:/home/cardano/keys
```

