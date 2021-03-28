# Raspberry PI Cardano Staking Pool - Educational

In this project you will find resources for building progressively more complex Raspberry PI powered,
cardano stake pools.

If you enjoyed the content of this project, please consider donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

In order to minimise the dependency on the underlying operating system you're using on your Raspberry PI, we will
make large use of containerised applications. In particular, we will build AND use docker images.
On top of this, we will leverage the USB 3.0 capabilities and connect SSD via sata to USB in order to have about 4 times 
faster disk IO.

Before starting to work with the cardano node, we have to prepare the Raspberry PI. These are all the required steps:

1. Flash the SD card and update the Raspberry PI firmware [docs](/MICRO_SD.md)
2. Flash the SSD drive and install ubuntu 20.04 [docs](/SSD.md)
3. Install Docker [docs](/DOCKER.md)
4. Build the `cardano-node` docker image [docs](/BUILD_CARDANO_NODE.md)
5. Launch a Relay Node
    * Download the blockchain
6. Generate Stake Pool certificates and keys
7. Launch the Block Producing node
