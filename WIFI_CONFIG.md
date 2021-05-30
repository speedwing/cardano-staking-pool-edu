# Config WiFi for Ubuntu

Now that the Raspberry PI is set up and able to boot from the SSD with Ubuntu. If you are connecting through WiFi, you need first to config Ubuntu to connect to your network automatically, so you can continue working remotely via SSH:

1. Connect a keyboard and a display directly on to your Raspberry PI.
2. Turn on the Raspberry PI (connecting the power cable). After booting is complete you will be asked to login to Ubuntu for the first time.
3. Use "ubuntu" both as a user and password to login.
4. You will be asked to enter a new password. Do it (and remember it).

5. Find wifi card name:
```bash
$ ls /sys/class/net
  
  eth0  lo  wlan0
```
(in this case wlan0 is the name)

6. Edit network configuration file to add WiFi info:

```bash
$ sudo vi /etc/netplan/50-cloud-init.yaml
```
you will see the following in the original file:

```
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
```

and you need to add the following:

```
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
        wlan0:
            optional: true
            access-points:
                "my-wifi-name":
                    password: "my-wifi-password"
            dhcp4: true
```
(where wlan0, my-wifi-name, my-wifi-password, need to be replaced with your data. Also please make sure that you are very careful with indentation).

7. Save the file.

8. You also need to do this:

```bash
$ sudo vi /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
```
add only this line:
```
network: {config: disable}
```

9. Save the file.

10. Reboot the Raspberry PI

And that's it, after rebooting, you will have access to Raspberry Pi without Ethernet wire! You can now unplug the keyboard and display, and continue working via SSH (from your laptop).
