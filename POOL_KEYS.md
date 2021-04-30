# Pool Keys

This part of the proces of setting up a pool used to be extremely painful. While the official cardano [docs](https://docs.cardano.org/projects/cardano-node/en/latest/index.html)
are extremely well written, it is complicated to do all the steps by hand, specially if you consider that signed transaction should promptly be
submitted, or they will expire, and you will have to create them again.

For this reason we will use the [scripts](https://github.com/gitmachtl/scripts) of Martin the SPO of the [ATADA](https://adapools.org/pool/00000036d515e12e18cd3c88c74f09a67984c2c279a5296aa96efe89) Stake Pool.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Install required libraries

ATADA scripts require a program called jq used to manage json.

```shell
sudo apt-get update && sudo apt-get install -y jq
```

## Update project source

Ensure you're on the latest and greatest version of this docs

```bash
cd ~/cardano-staking-pool-edu && git pull --rebase
```

## Create all the certificates
The first step is to clone or update the ATADA Scripts. Ssh into you pi and clone

```shell
cd ~ && git clone --depth 1 https://github.com/gitmachtl/scripts.git
```

or update the scripts

```shell
cd ~/scripts && git pull --rebase
```

## Prepare the environment

First step is to create folder for the keys

```shell
mkdir -p /home/ubuntu/.keys/testnet
```

Replace `testnet` with `mainnet` if you're planning to use this for mainnet.

We will need to use `cardano-cli` to interact with the `cardano-node` during the registration of the pool, so we 
need to extract these binaries from the docker image. I've prepared a couple of scripts to do so. You will need to run
these every time there is version update.

Scripts are available in [misc/atada](#misc/atada)

```shell
cd /home/ubuntu/cardano-staking-pool-edu/misc/atada && \
  ./extract-cardano-binaries.sh && \
  ./init-testnet.sh
```

Depending on which blockchain you're using (testnet or mainnet), you will be prompted to update your `PATH` env var, this 
is going to be super handy to have direct access to the ATADA scripts.

The instruction should look something like:

`export PATH=/home/ubuntu/scripts/cardano/testnet:[...]`

Copy, paste and execute it. We are now ready to create all-the-certs

## Create the required address and certificates

```shell
# Change to the keys folder previously created
cd /home/ubuntu/.keys/testnet

# Create payment address, verification and signature key
02_genPaymentAddrOnly.sh africa cli

# Create staking files 
03a_genStakingPaymentAddr.sh africa cli
```

We now need to transfer some $tAda (test Ada). We will use the testnet faucet: https://developers.cardano.org/en/testnets/cardano/tools/faucet/

Extract the payment address from the payment file `cat africa.payment.addr`, the result should be something similar to

`addr_test1qpat2377zxrqytzydxmwsgvfc37273wgalrpdtx6xdxnzpdsx7qjpcfupg06qpw3uezee7cnsqyf4ffm75e9uln7ya4sq2zrug`

Use this address in the faucet to get your money.

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
04a_genNodeKeys.sh afric cli


```

