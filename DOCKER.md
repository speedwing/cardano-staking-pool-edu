# Docker

In this third part of the tutorial, we are going to install [Docker](https://www.docker.com/). The reason is very simple,
we do not want to have to deal with the underlying Operating System, and go crazy when updates are needed. 
A couple of examples are Cabal and the GHC. Keeping them updated is important but messy. Having everything into containers
greatly simplifies the management of the node.

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

## How to install Docker

There are a number of different ways of installing Docker. I found using snap, the new ubuntu packer manager, VERY simple.

All that you need to do is:

`sudo snap install docker`

Now that `docker` is installed, we need to give the `ubuntu` user, permissions to use it without requiring `sudo` 
privileges.

All that we need to do is to create a group and assign the ubuntu user to it.

```bash
sudo addgroup --system docker
sudo adduser ubuntu docker
newgrp docker
```

and then restart the docker service

```bash
sudo snap disable docker
sudo snap enable docker
```

On youtube I received the comment: 

> Hi.  I see this Warning during the build " ---> [Warning] Your kernel does not support memory limit capabilities or the cgroup is not mounted. Limitation discarded.
Is this going to be a problem for me?

So I quickly checked and yes there is an extra step to take in order to enable memory and cpu capabilities. Details below.

## Enabling cgroup

Now that docker is installed, we have to add [cgroup](https://en.wikipedia.org/wiki/Cgroups) capabilities. These are
required in order to make visible to containers cpu and memory resources.

It is really really simple to do so, first edit this file `sudo vi /boot/firmware/cmdline.txt` 
and add `cgroup_enable=memory cgroup_memory=1` at the end of the uniq line of the file (not a new line as it won't work)

The result should be something like:
```bash
ubuntu@ubuntu:~$ cat /boot/firmware/cmdline.txt
net.ifnames=0 dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=LABEL=writable rootfstype=ext4 elevator=deadline rootwait fixrtc cgroup_enable=memory cgroup_memory=1
```

In order for these changes to take effect, you have to reboot your pi, so simply run `sudo reboot now`

And this is for this episode. 
