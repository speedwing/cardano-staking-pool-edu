# Pool Keys

> **NOTE 1**: I realised I had to fix some root vs non-root permissions in an advanced stage of these series of tutorials. If while you follow this 
> episode you suddenly experience issues with root vs non-root permissions, please check the following [docs](/RUN_NODE_AS_USER.md) 
> and then come back to this episode.

> **NOTE 2**: Before starting it's important to know that there is a step of this tutorial I just can't help you with, and it is the setup of your
> router and/or how to configure dynamic ip addresses. This is because there are way too many different setups.

This part of the process of setting up a pool used to be extremely painful. While the official cardano [docs](https://docs.cardano.org/projects/cardano-node/en/latest/index.html)
are extremely well written, it is complicated to do all the steps by hand, specially if you consider that signed transaction should promptly be
submitted, or they will expire, and you will have to create them again.

For this reason we will use the [scripts](https://github.com/gitmachtl/scripts) of Martin the SPO of the [ATADA](https://adapools.org/pool/00000036d515e12e18cd3c88c74f09a67984c2c279a5296aa96efe89) Stake Pool.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Update project source

Ensure you're on the latest and greatest version of this project

```bash
cd ~/cardano-staking-pool-edu && git pull --rebase
```

## Build the ATADA scripts docker image

```bash
cd ~/cardano-staking-pool-edu/atada-scripts/ && ./build-atada-scripts.sh
```

## Prepare the keys folder

Please note that, after creation, all your keys and certificates, except for the operational cert, KES verification signature key, and VRF signature key,
MUST be saved OUTSIDE the raspberry pi. Should your raspberry pi be compromised, a hacker won't be able to withdraw your funds or compromise your stake pool

The default folder we will use for thi tutorial is:

```shell
mkdir -p /home/ubuntu/.keys/testnet
```

Replace testnet with mainnet if required.

## Run the atada container 

This part of the tutorial needs to be followed the first time you're creating your keys, and every time you need to 
updated your operational certificate or need to rotate you KES Keys.

```bash
cd ~/cardano-staking-pool-edu/atada-scripts/ && ./run-atada-scripts.sh
```

Once the container is launched, we have to set the environment for the proper network (i.e. mainnet or testnet)

```shell
cd /home/cardano/atada && ./init-testnet.sh 
```

The script should spit a line that looks like:

`export PATH=/home/cardano/scripts/cardano/testnet:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`

Copy it, and execute it. This will put the network specific ATADA scripts on your path.

Time to create the various certificates

### Create the required address and certificates

These docs have been written the week of the first Africa Cardano deal, the one about 5m Ethiopian students being
onboarded on the blockchain. To celebrate this, we will create certs and keys for a test net pool called AFRIC.

```shell
# Change to the keys folder previously created
cd /home/cardano/keys

# Create payment address, verification and signature key
02_genPaymentAddrOnly.sh africa cli

# Create staking files 
03a_genStakingPaymentAddr.sh africa cli
```

> **NOTE**: the `cli` param passed to the ATADA scripts, can be replaced with other param that will allow you to use hardware wallets like ledger/trezor.
> Check their docs if you want to know more.

We now need to transfer some $tAda (test Ada). We will use the testnet faucet: https://developers.cardano.org/en/testnets/cardano/tools/faucet/

Extract the payment address from the payment file `cat africa.payment.addr`, the result should be something similar to

`addr_test1qpat2377zxrqytzydxmwsgvfc37273wgalrpdtx6xdxnzpdsx7qjpcfupg06qpw3uezee7cnsqyf4ffm75e9uln7ya4sq2zrug`

Use this address in the [faucet](https://developers.cardano.org/en/testnets/cardano/tools/faucet/) to get your money.

If you are on mainnet, that's the moment where you transfer from your wallet or from an exchange. Please note that you will:
1. 500 $ada as deposit for your Stake Pool
2. The amount of $ada you desire to pledge
3. Some extra couple of $ada for paying transaction fees

The faucet gives us 1000 $ada, that is perfect for this exercise.

After a few seconds we should have the $tAda in our wallet, let's continue

```shell
# Ensure funds have arrived
01_queryAddress.sh africa.payment

# Register Stake address 
03b_regStakingAddrCert.sh africa.staking africa.payment # press 'Y' when prompted 

# Wait for stake address to be registered
03c_checkStakingAddrOnChain.sh africa

# Generate Node keys 
04a_genNodeKeys.sh africa cli

# Generate vrf keys
04b_genVRFKeys.sh africa

# Generate KES keys
04c_genKESKeys.sh africa

# Generate Node Operational cert
04d_genNodeOpCert.sh africa

# Generate Stake Pool Cert
05a_genStakepoolCert.sh africa
```

Right, we've generated most of our keys, but now we need to customise the pools characteristics. 

Here we are going to assume there is just one owner, and it's yourself. Edit the `vi africa.pool.json` with your favourite cli editor, and set

* `ownerName`: `africa`
* `poolRewards`: `africa`
* `poolPledge`: pool pledge in lovelace. So 100 $ada is 100000000
* `poolCost`: 340000000 (this is the minimum)
* `poolMargin`: 0.10 means 10%, 0.02 means 2%
* `relayType`: whether you're going to use a static ip or a dns name
* `relayEntry`: the value of the type above. if you set up ip, you should set something like `123.123.123.123`, if dns something like `my-relay.my-domain.com`
* `relayPort`: the port number at which your node is listening for incoming connections
* `poolMetaName`: the name of the stake pool, not the ticker, this can be longer.
* `poolMetaDescription`: description of your pool, this could be a motto, or the charity you're donating to
* `poolMetaTicker`: the ticker. A 5 digit name for you pool. Letter, numbers and some symbol definitely accepted.
* `poolMetaHomepage`: self explanatory
* `poolMetaUrl`: the url of the pool metadata. You can use git gists. TODO: insert link to video with the tricky bit

We can now resume with the certificates creation and registration.

```shell
# Re-execute after the changes, so that the metadata file gets created.
05a_genStakepoolCert.sh africa

# Generate Delegation Certificate
05b_genDelegationCert.sh africa africa.staking

# Register Stake Pool Certificate
05c_regStakepoolCert.sh africa africa.payment

# Register Delegation Certificate
06_regDelegationCert.sh africa africa.payment
```

Congratulations. Your pool is not registered.
