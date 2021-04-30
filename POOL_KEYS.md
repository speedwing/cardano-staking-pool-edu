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

We can now proc
