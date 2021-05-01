# Run node as user

I've recently decided to fix something that has been bothering me for a while.

The docker images that we were creating were all running as `root`. While container virtualization security 
has massively improved and running as root is not necessarily _too much of a big deal_, it's always better to 
run container as normal user as much as possible.

Also, as we are now starting to manage node certificates and cardano addresses with actual money inside, it's necessary
to prevent accidental malicius code from screwing us up big time.

For this reason, I've reworked the docker images, and I've created relevant users so to run containers in non-root mode.

Unfortunately, this means that some fixes have to be applied IF you've been following these tutorials BEFORE I fixed the images.

## The fix

First, let's re-create the images with the proper users.

```bash
# Ensure we are on the latest commit
cd ~/cardano-staking-pool-edu && git pull --rebase
```

Let's re-build the node
```bash
cd ~/cardano-staking-pool-edu/cardano-node && ./build-cn-X.Y.Z.sh > /dev/null &
````

Where `X.Y.Z` is the version of the node you're running.

If you've successfully done this in the past, it should not take too long.

Now stop the node running on the pi:
```bash
docker stop cardano-node-testnet
docker rm cardano-node-testnet
```

Fix cardano-node db folder permissions:

```bash
sudo chown -R ubuntu:ubuntu ~/cardano-node/
```

You can now restart the [node](/RELAY_MODE.md)
