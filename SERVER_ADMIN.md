# Server Admin

This guide assumes you're on ubuntu.

# Update and upgrade the system

sudo apt-get update && \ 
    sudo apt-get full-upgrade -y
    
Once ran the command above (the `full-upgrade` or `dist-upgrade` one) and you are running on SSD, ensure that no new
kernel was installed. Should that be the case, or if unsure, visit [SSD](/SSD.md)

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

## Installing Kubernetes with SNAP

* [Full documentation](https://microk8s.io/docs)
* [ARM Specific](https://microk8s.io/docs/install-alternatives#heading--arm)

For arm, edit `sudo vi /boot/firmware/cmdline.txt`
And add at the end of the line `cgroup_enable=memory cgroup_memory=1`

Then install with `sudo snap install microk8s --classic`

Add user to microk8s users' group

```bash
sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube
su - ubuntu
```

### Aliases

```bash
echo "alias k='microk8s kubectl'
alias kubectl='microk8s kubectl'
alias helm='microk8s helm3'" > ~/.bash_aliases
source ~/.bash_aliases
```

### Hosts and hostnames

Change hostname via `sudo vi /etc/hostname` with `pi-(one|two...)`

And then host via `sudo vi /etc/hosts`

```bash
192.168.0.10 pi-one
192.168.0.11 pi-two
192.168.0.12 pi-three
192.168.0.13 pi-four
```