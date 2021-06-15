# Raspberry PI Cardano Staking Pool - Educational

In this project you will find resources for building progressively more complex Raspberry PI powered,
cardano stake pools.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## Required hardware

* At lest 1 Raspberry PI 4B 8gb
* One microSD
* One SSD Drive, at least 64GB
* A Raspberry PI power adapter (or a phone charger with USB-C plug)
* A network cable to connect your PI to the router (no WIFI)

## Disclaimer

This tutorial is aimed to provide educational content to create a Cardano **testnet** Stake Pool. This guide is
by no means a replacement of the [Cardano Node official documentation](https://docs.cardano.org/projects/cardano-node/en/latest/#). 

Beware that, in case you decide to use this tutorial for spinning your own pool in **mainnet**, I take no 
responsibility for any loss of $ada you may face for improperly setting up, managing, update you stake pool.
Please ensure you're proceeding with creating a **mainnet** stake pool only after you've reached a certain level
of confidence when operating the pool.

While following this tutorial, you will have to handle delicate hardware parts, like the board of the Raspberry PI,
the microSD card and the SSD drive, plus any additional other hardware component like a case or cooling system.

I do not take any responsibility for any damage to any hardware component or apparel you may be using while following
this tutorial.

Furthermore, because you may need, in case of mistakes or errors, to erase the microSD or SSD card, ensure sensitive
data are safely and appropriately backed up.

Follow this tutorial at your own risk. No responsibility are taken of any hardware failure or $ada loss during the process.

## Why docker

In order to minimise the dependency on the underlying operating system you're using on your Raspberry PI, we will
make large use of containerised applications. In particular, we will build AND use docker images.
On top of this, we will leverage the USB 3.0 capabilities and connect SSD via sata to USB in order to have about 4 times 
faster disk IO.

Before starting to work with the cardano node, we have to prepare the Raspberry PI. These are all the required steps:

1. Flash the SD card and update the Raspberry PI firmware [docs](/MICRO_SD.md)
2. Flash the SSD drive and install ubuntu 20.04 [docs](/SSD.md)
3. Install Docker [docs](/DOCKER.md)
4. Build the `cardano-node` docker image [docs](/BUILD_CARDANO_NODE.md)
5. Launch a Relay Node [docs](/RELAY_MODE.md)
    * Download the blockchain
6. Disable password auth mechanism for SSH [docs](/SSH.md)
7. Generate Stake Pool certificates and keys [docs](/POOL_KEYS.md)
8. Launch the Block Producing node [docs](/BP_MODE.md)

> **NOTE**: If you're suddenly experiencing issues with root vs non-root users, please check the following [docs](/RUN_NODE_AS_USER.md)

## Additional docs

* How to check node synchronization: [Node synchronization](/NODE_SYNCHRONIZATION.md)
* How to set-up a monitoring system with Prometheus/Grafana [docs](/Setup_Monitoring_System_Cardano_Node.pdf)
