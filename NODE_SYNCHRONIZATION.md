# Node Synchronization

Both relay and block-producing node, in order to work, must be synchronised with the 
blockchain. This means that they must, within seconds, be able to _see_ the last block.
In cardano the _last block_ is called tip.

You can easily check what is the tip of your relay or bp node by issueing a query. You
can then check on the explorer (either testnet or mainnet) to verify your node is
synced.

## How to check the tip

First of all ssh into the raspberry pi. Then check if your node is running:

```bash
ubuntu@ubuntu:~$ docker ps
```
The result should be something like:

```bash 
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS                  PORTS               NAMES
4598d32b54c2        cardano-node:1.27.0-aarch64   "bash -c 'cardano-no…"   46 hours ago        Up 46 hours (healthy)                       cardano-node-testnet
```

Then _ssh_ into the pi as follow:
```bash
ubuntu@ubuntu:~$ docker exec -it cardano-node-testnet bash
```

You should now see a different prompt, something similar to:
```bash
cardano@4598d32b54c2:~$
```

Now you have access to the `cardano-cli` and can query the tip and compare on the blockchain explorer.

Cardano explorers:
* Mainnet [https://explorer.cardano.org/en](https://explorer.cardano.org/en)
* Testnet [https://explorer.cardano-testnet.iohkdev.io/en](https://explorer.cardano-testnet.iohkdev.io/en)

> **NOTE**: you don't have to run the date command, here I do so to demonstrate at what time I'm running this.

From within the container, run the following (no need to run `date`):

```bash
cardano@4598d32b54c2:~$ date
Wed Jun  2 08:26:12 UTC 2021
cardano@4598d32b54c2:~$ cardano-cli query tip --testnet-magic 1097911063
{
    "epoch": 135,
    "hash": "69a83277a4873e2835236d40f331e3b3e8266bbf8c871d232a9be676be28c5d7",
    "slot": 28253119,
    "block": 2636090,
    "era": "Mary"
}
```

Now copy the `hash` of the tip and open the explorer and paste the hash in the search field and press enter.

![Testnet query tip](/images/testnet-tip-example.png "Example Testnet tip")

As you can see, current time matches the time of the tip. This means your node is
synced with the blockchain and is ready to receive commands (relay node) or mint blocks.
