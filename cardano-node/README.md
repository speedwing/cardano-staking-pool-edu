# Building an Ubuntu Based cardano node docker image

> **NOTE** It is good habit to build your own docker images and not trust what's on docker hub as it's very easy to
sneak in malicious images that can leak your secrets.

> **NOTE** Because of the note above, before building and using any of the docker images whose dockerfile is published on this 
> repository, you're invited to carefully review such dockerfile so to be sure you're happy with their content. 

In this module you will find all the building blocks to successfully create a cardano-node docker image for
both `x86_64` and `aarch64`

## Cabal

Cabal 3.2.0.0 needs to be built independently because it requires a specific version of GHC.

Use the `build-cabal-3.2.0.0.sh` script to build your own image. 

## Gotchas

Ubuntu version vs Debian version

https://askubuntu.com/questions/445487/what-debian-version-are-the-different-ubuntu-versions-based-on