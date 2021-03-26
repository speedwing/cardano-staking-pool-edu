# Boot from SSD

Now that the Raspberry PI has the latest and greatest firmware, we can now proceed to set up the boot from the SSD.
This is divided into three steps:

1. Flash the SSD drive with Ubuntu 
2. Update the boot configuration of the newly flashed SSD
3. Update the RPI boot configuration


## Install Ubuntu 20.04 on the SSD

In this section we will install Ubuntu on the SSD drive and apply all the changes required by the Raspberry PI to boot
properly from the SSD without needing an SD card at all.

1. Plug the SSD to the PI (used the SATA to USB adapter). Please use the USB blue port on the PI as it's FASTER.
2. Turn on the PI if it was off. 
3. Find the device id `lsblk`

you should see something like: 
```bash
pi@raspberrypi:~ $ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 223.6G  0 disk
mmcblk0     179:0    0  59.5G  0 disk
├─mmcblk0p1 179:1    0   256M  0 part /boot
└─mmcblk0p2 179:2    0  59.2G  0 part /
```

The `mmcblk0` is the Micro SD card, while `sda` if present is your SSD drive. Please note this could actually be called `sdb` too.

4. Erase the SSD drive `sudo mkfs.ext3 /dev/sda`
5. Download the ubuntu distribution for Raspberry Pi
    * cd && curl -LO https://cdimage.ubuntu.com/releases/20.04.2/release/ubuntu-20.04.2-preinstalled-server-arm64+raspi.img.xz
6. Flash the ubuntu distribution on the SSD `xzcat ubuntu-20.04.2-preinstalled-server-arm64+raspi.img.xz | sudo dd of=/dev/sda bs=32M`
    * wait
    * wait
    * wait (yeah I know nothing is priting on the terminal)
    * wait
    * oh it's done.
7. Then execute
```bash
sudo mkdir /mnt/boot
sudo sudo mount /dev/sda1 /mnt/boot
cd ~ && git clone --depth 1 https://github.com/raspberrypi/firmware
cd ~/firmware/boot && \
  sudo cp *.dat /mnt/boot && \
  sudo cp *.elf /mnt/boot && \
  zcat < /mnt/boot/vmlinuz > /tmp/vmlinux && \
  sudo cp /tmp/vmlinux /mnt/boot && \
  rm /tmp/vmlinux
```
8. In `vi /mnt/boot/config.txt` replace:
```bash
[pi4]
kernel=uboot_rpi_4.bin
max_framebuffers=2

[pi2]
kernel=uboot_rpi_2.bin

[pi3]
kernel=uboot_rpi_3.bin

[all]
arm_64bit=1
device_tree_address=0x03000000
```
with
```bash
[all]
arm_64bit=1
device_tree_address=0x03000000
kernel=vmlinux
initramfs initrd.img followkernel
```
9. Configure BIOS to boot from SSD, run  `sudo EDITOR=vi rpi-eeprom-config -e`
    * set update the line: `BOOT_ORDER=0xf41`

### Auto Extract vmlinuz

Raspberry pi cannot boot compressed kernel, so it needs to be automatically exploded upon update.

Copy and execute the script in misc [init-auto_decompress_kernel.sh](/misc/init-auto_decompress_kernel.sh)

=====

Backup original: BOOT_ORDER=0x1





