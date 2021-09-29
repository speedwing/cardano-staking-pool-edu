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
mkdir -p /home/ubuntu/cardano-node/testnet
cd ~/cardano-staking-pool-edu && git pull --rebase # Ensure we're on the latest version of the project
cd ~/cardano-staking-pool-edu/cardano-node && \
  NETWORK=testnet ./run-node.sh /home/ubuntu/cardano-node/testnet 3001 --restart unless-stopped
```

> NOTE: if you want to download mainnet instead, I would recommend to create the folder `/home/ubuntu/cardano-node/mainnet`
> and update the NETWORK variable to NETWORK=mainnet. The full command would look like:
> `cd ~/cardano-staking-pool-edu/cardano-node && NETWORK=mainnet ./run-node.sh /home/ubuntu/cardano-node/mainnet 3001 --restart unless-stopped`

You should see something like:
```bash
++ uname -m
+ OS_ARCH=aarch64
+ NODE_VERSION=1.29.0
+ IMAGE_TAG=1.29.0-aarch64
+ DB_FOLDER=/home/ubuntu/cardano-node/testnet
+ CARDANO_NODE_PORT=3001
+ NETWORK=testnet
+ NODE_MODE=relay
+ KES_SKEY_PATH=/root/keys/pool-keys/kes.skey
+ VRF_SKEY_PATH=/root/keys/pool-keys/vrf.skey
+ NODE_OP_CERT_PATH=/root/keys/pool-keys-17-01-2021/node.cert
+ [[ -z /home/ubuntu/cardano-node/testnet ]]
+ [[ -z 3001 ]]
+ echo 'Starting node with DB_FOLDER=/home/ubuntu/cardano-node/testnet and CARDANO_NODE_PORT=3001'
Starting node with DB_FOLDER=/home/ubuntu/cardano-node/testnet and CARDANO_NODE_PORT=3001
+ '[' relay = relay ']'
+ echo 'Starting node in RELAY mode'
Starting node in RELAY mode
+ sleep 5
+ docker run --name cardano-node-testnet -d --rm -v /home/ubuntu/cardano-node/testnet:/db -e CARDANO_NODE_SOCKET_PATH=/db/node.socket cardano-node:1.29.0-aarch64 'cardano-node run     --topology /etc/config/testnet-topology.json     --database-path /db     --socket-path /db/node.socket     --host-addr 0.0.0.0     --port 3001     --config /etc/config/testnet-config.json'
f35c34fafa38a0b2ad2fa202482b24e4be65e098f9f447d7f9902dffc6157226
```
as output.

In particular the `f35c34fafa38a0b2ad2fa202482b24e4be65e098f9f447d7f9902dffc6157226` is the id of the container runnin the 
`cardano-node`.

After a few seconds, issue the `docker ps` command and check if the node is still running. Something like this should be printed:
```bash
CONTAINER ID        IMAGE                         COMMAND                  CREATED              STATUS              PORTS               NAMES
f35c34fafa38        cardano-node:1.29.0-aarch64   "bash -c 'cardano-no…"   About a minute ago   Up About a minute                       cardano-node-testnet
```

There we go, our relay is up and running and possibly downloading the blockchain from the beginning. Let's see if it's true.

Run `docker logs cardano-node-testnet` something like this should be printed:

```bash
[f35c34fa:cardano.node.ChainDB:Notice:34] [2021-03-30 12:16:10.98 UTC] Chain extended, new tip: 3b7ce29c578a1a522fa4bab9aaba0e194aafda05748e8af026e61b0fa65ff867 at slot 4758
[f35c34fa:cardano.node.ChainDB:Notice:34] [2021-03-30 12:16:12.28 UTC] Chain extended, new tip: 90ee6552293568253b6996faa68058941ce9b10f99456bb013e6d7b53c4f8deb at slot 4786
[f35c34fa:cardano.node.ChainDB:Notice:34] [2021-03-30 12:16:13.59 UTC] Chain extended, new tip: be45e282614e01138408ee142ee570dca8f8d18da9da0596679e7c95ae91c7f3 at slot 4810
[f35c34fa:cardano.node.ChainDB:Notice:34] [2021-03-30 12:16:14.89 UTC] Chain extended, new tip: 5443643aaa23dae9295219d227f859f1fab161b368b2ed937628a4ed1cd8b1f9 at slot 4832
```

Bingo, our node is download the blockchain. Let's check this tip `5443643aaa23dae9295219d227f859f1fab161b368b2ed937628a4ed1cd8b1f9` at what 
epoch belongs. Let' open the cardano blockchain explorer for testnet.

The cardano testnet blockchain explorer is available at: `https://explorer.cardano-testnet.iohkdev.io`

The URL for that specific tip is: `https://explorer.cardano-testnet.iohkdev.io/en/block?id=5443643aaa23dae9295219d227f859f1fab161b368b2ed937628a4ed1cd8b1f9`, and 
you can see the block is dated `2019/07/25 23:10:56 UTC`. We will need to check this manually from time to time to see when the full
blockchain is finally downloaded. 

Congrats on completing this episode!
