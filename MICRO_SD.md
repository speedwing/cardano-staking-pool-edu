# Update Raspberry PI firmware

In this first part of the tutorial, we will upgrade our Raspberry PI firmware so to be able to boot from SSD.

## Prepare the SD Card

In order to make the Raspberry PI to boot on a SSD drive, there are a number of steps that need to be taken.
The first step is to ensure the last version of the BIOS.

In order to achieve this:

1. Download and install the [RPI Imager](https://www.raspberrypi.org/software/)
2. Insert the SD 
3. Launch the RPI Imager and select:
    * Raspberry PI OS (32-BIT)
    * Select the SD Card
    * Press write (enter admin password)
4. Extract and re-insert the Micro SD
5. Create an empty file in the SD called `ssh` (it is required to enable remote ssh)

## Boot the PI for the first time

You can now:
1. Insert the Micro SD in the PI
2. Connect the PI to the lan via the cable (I won't bother setting up the wifi)
3. Power the PI

We have now to discover the IP of the pi.

We will need to run `nmap` to find our Raspberry PI into the network, but first we have to find out our IP
so that we can limit `nmap` to just a limited subranges of IP addresses.

Run `ifconfig en0`, you should see something like
```bash
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether XX:XX:XX:XX:XX:XX
	inet6 fe80::189b:ac2a:f720:d26e%en0 prefixlen 64 secured scopeid 0x6
	inet 192.168.0.94 netmask 0xffffff00 broadcast 192.168.0.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
```

The IP is the one at the line `inet` and is `192.168.0.94` or it could look something like `172.18.0.54`.

It the `ifconfig en0` returns nothing, try this one instead: `ifconfig -a | grep inet`

Among all the results, try to find something similar to the IP listed above. Once found, we can now search for our 
the IP address of our Raspberry PI, so run:

`sudo nmap -sP 192.168.0.0/24` 

Where the `192.168.0.0/24` is composed by the beginning of your IP Address `192.168.0.` and a mask `0/24`.

Results should look something like:

```bash
[...]
Nmap scan report for 192.168.0.13
Host is up (0.00031s latency).
MAC Address: DC:A6:32:D7:1E:91 (Raspberry Pi Trading)
[...]
```
So you have to look for "Raspberry Pi Trading", and two lines above there will be the IP Address of your PI. In this case
`192.168.0.13`. Well done. You've found your PI!

You can now SSH into it with:

`ssh 192.168.0.3 -l pi`

Password is `raspberry`

##  Upgrade all-the-things

Now that you're into the PI, you can update all the things by running

`sudo apt-get update && sudo apt-get dist-upgrade`
