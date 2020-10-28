# Server Admin

This guide assumes you're on ubuntu.

# Update and upgrade the system

sudo apt-get update && \ 
    sudo apt-get upgrade -y && \
    sudo apt-get dist-upgrade
    
## Disable SSH w/ password

This guide assumes you've setup already SSH keys to log w/o password on such hosts. Check the linked guide below 
if you haven't yet.

Update SSH server configuration with:

`sudo vi /etc/ssh/sshd_config`

Set following values

```
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
PermitRootLogin no
```

Restart ssh server

`sudo service ssh reload`

[source](https://www.cyberciti.biz/faq/how-to-disable-ssh-password-login-on-linux/)

### How to test

ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no <host> -l <user>

[source](https://unix.stackexchange.com/questions/15138/how-to-force-ssh-client-to-use-only-password-auth)