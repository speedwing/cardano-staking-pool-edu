# Build the cardano node

This is gonna be a short episode, BUT the PI will be working for hours and hours. Possibly the whole day/night.

What we will be doing here is to build the `cardano-node` from scratch because currently the foundation is not providing 
us with official docker images. For this reason we will build our own. It's important to know that you should NOT trust 
public docker images for the `cardano-node` for raspberry pi. They could potentially steal your keys and give access to your
funds to other people.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## How to build the `cardano-node`

There is really just one step here, actually two if you haven't checked out already the github project of this tutorial.

1. Clone, if you haven't done it yet (it is a step in a previous episode) the project
```bash
cd ~ && git clone --depth 1 https://github.com/speedwing/cardano-staking-pool-edu.git
```
If this commands ends in error, you already have the project checked out. So to be sure you're on the latest version 
run the following:
```bash
cd ~/cardano-staking-pool-edu && git pull --rebase
```
This will take you to the latest version.
2. Build the `cardano-node` by issuing:
```bash
cd ~/cardano-staking-pool-edu/cardano-node && ./build-cn-1.26.1.sh > /dev/null &
````
The build should have started, you can actually check that it is progressing by running `docker ps`. You should see something like:
```bash
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
458ecda1f05d        1e67d4ea1867        "/bin/sh -c 'cd libs…"   About a minute ago   Up About a minute                       charming_kilby
```
If that's the case, you PI has just started to build the image. Congrats. 

As anticipated, this will take hours and hours. So consider coming back in 4 to 8 hours.

Now, it's quite a while that the PI has been crunching, so let's check that it is still either in progress or completed.
Run `docker ps`.
If you see something like the above entry
```bash
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
458ecda1f05d        1e67d4ea1867        "/bin/sh -c 'cd libs…"   About a minute ago   Up About a minute                       charming_kilby
```
It means your PI is still going.

If you instead have something like
```bash
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
```
It means the PI has either completed in error or succeeded. Let's find out, run `docker images`.
If you can find:
```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
cardano-node        1.26.0-aarch64      659c2616f6ac        41 hours ago        3.1GB
```
Well, my friend, you and your PI did it.

If you can't find the `cardano-node` in the results, there must have been an error.

Look for the logs in `/tmp/cardano-node-build.logs`, and try to find the error, usually it is at the end of the file.
You can check by using `tail -n 100 /tmp/cardano-node-build.logs`. Copy the error and try to figure out what's wrong.



