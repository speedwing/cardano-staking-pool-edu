# Relay Mode and download the Blockchain

Congratulations if you made it this far! It wasn't easy, so be very proud of yourself.
This step is going to be hopefully easy too, but it will required a bit of patience. Also, it's a step where you may
want to consider customising the option parameters depending on how you want to set up your pool. A couple of customizations
could be the data folder where to save the blockchain, or the port number you want to expose.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Running the node in Relay mode.

> Just a reminder that this tutorial will focus on how to create a Block Producing node (BP) on **testnet**

Starting the node in relay mode for testnet should be as easy as:

```bash
mkdir -p /var/cardano-node/testnet
cd ~/cardano-staking-pool-edu && git pull --rebase # Ensure we're on the latest version of the project
cd ~/cardano-staking-pool-edu/cardano-node && \
  NETWORK=testnet ./run-node.sh /var/cardano-node/testnet 30001 
```