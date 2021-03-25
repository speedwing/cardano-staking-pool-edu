# SSD


sudo EDITOR=vi rpi-eeprom-config -e


## Raspberry Pi 4 - Boot from SSD
* https://eugenegrechko.com/blog/USB-Boot-Ubuntu-Server-20.04-on-Raspberry-Pi-4
* https://www.tomshardware.com/how-to/boot-raspberry-pi-4-usb
* https://www.jeffgeerling.com/blog/2020/im-booting-my-raspberry-pi-4-usb-ssd
* https://lemariva.com/blog/2020/08/raspberry-pi-4-ssd-booting-enabled-trim

### Steps

## Flash the card or SSD from cli

* [image](https://cdimage.ubuntu.com/releases/20.04.1/release/ubuntu-20.04.1-preinstalled-server-arm64+raspi.img.xz)
* [source](https://askubuntu.com/questions/1193232/how-do-i-use-an-img-xz-file-or-get-an-img-file-from-it)
* [source](https://ubuntu.com/download/iot/installation-media)




Boot the rpi from microsd and run

```
sudo apt-get update && \
    sudo apt-get upgrade -y && \
    sudo apt-get dist-upgrade && \
    sudo apt-get full-upgrade -y
```

Flesh the SSD w/ Ubuntu 64

Checkout `https://github.com/raspberrypi/firmware/tree/master/boot`

```
cp ~/Downloads/firmware-/boot/*.dat /
cp ~/Downloads/firmware-/boot/*.elf /
zcat < vmlinuz > vmlinux
```

Set the `config.txt` to:

```
[all]
arm_64bit=1
device_tree_address=0x03000000
kernel=vmlinux
initramfs initrd.img followkernel
```

### Additional BIOS settings

```bash
[all]
BOOT_UART=0
WAKE_ON_GPIO=1
POWER_OFF_ON_HALT=0
DHCP_TIMEOUT=45000
DHCP_REQ_TIMEOUT=4000
TFTP_FILE_TIMEOUT=30000
TFTP_IP=
TFTP_PREFIX=0
BOOT_ORDER=0xf41
[none]
FREEZE_VERSION=0
```

### Auto Extract vmlinuz

Raspberry pi cannot boot compressed kernel, so it needs to be automatically exploded upon update.

Copy and execute the script in misc [init-auto_decompress_kernel.sh](/misc/init-auto_decompress_kernel.sh)

## Managing and additional SSD drive
Nice guide: https://linuxhint.com/list-usb-devices-linux/

* lsblk: `List information about block devices.`
* Format device: sudo mkfs.ext3 /dev/sda2
