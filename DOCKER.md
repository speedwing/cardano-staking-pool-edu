# Docker

In this third part of the tutorial, we are going to install [Docker](https://www.docker.com/). The reason is very simple,
we do not want to have to deal with the underlying Operating System, and go crazy when updates are needed. 
A couple of examples are Cabal and the GHC. Keeping them updated is important but messy. Having everything into containers
greatly simplifies the management of the node.

If you enjoyed the content of this project, please consider donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

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

And this is for this episode. 

