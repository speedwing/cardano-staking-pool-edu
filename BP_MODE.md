# Run in Block Producing (BP) Mode

Finally we made it to the last step of this tutorial. I assume you've got the blockchain downloaded by now and you've also got all
the keys and certificates required to run your block producing node.

TODO make list of requirements
Before proceeding remember that you will need:
* Either 

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Running the node in BP mode.

> Just a reminder that this tutorial will focus on how to create a Block Producing node (BP) on **testnet**

Starting the node in bp mode for testnet should be as easy as:

```bash
cd ~/cardano-staking-pool-edu && git pull --rebase # Ensure we're on the latest version of the project
cd ~/cardano-staking-pool-edu/cardano-node && \
  NETWORK=testnet ./run-node.sh /home/ubuntu/cardano-node/testnet 30001 --restart unless-stopped
```

