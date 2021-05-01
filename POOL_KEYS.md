# Pool Keys

> **NOTE**: I realised I had to fix some root vs non-root permissions in an advanced stage of these series of tutorials. If while you follow this 
> episode you suddenly experience issues with root vs non-root permissions, please check the following [docs](/RUN_NODE_AS_USER.md) 
> and then come back to this episode.

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

##£ Create the required address and certificates

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

# Generate node keys 
04a_genNodeKeys.sh africa cli
```

