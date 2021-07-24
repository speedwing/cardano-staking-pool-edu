# Boot from SSD

Now that the Raspberry PI has the latest and greatest firmware, we can now proceed to set up the boot from the SSD.
This is divided into three steps:

1. Flash the SSD drive with Ubuntu 
2. Update the boot configuration of the newly flashed SSD
3. Update the RPI boot configuration

If you are enjoying the content of this project, please consider supporting me by delegating to my stake pool, ticker EASY1 or
donating ₳D₳ to: addr1qyma8s3sehdhn626ls5v8y3xwm0w7lhlwqznxggnw4slcwavatgc4hdkune2k9xalx3tgskrva0g243ehggg8wkkpzdquegjwp

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
sudo mount /dev/sda1 /mnt/boot
cd ~ && git clone --depth 1 https://github.com/raspberrypi/firmware
cd ~/firmware/boot && \
  sudo cp *.dat /mnt/boot && \
  sudo cp *.elf /mnt/boot && \
  zcat < /mnt/boot/vmlinuz > /tmp/vmlinux && \
  sudo cp /tmp/vmlinux /mnt/boot && \
  rm /tmp/vmlinux
```
8. In `sudo vi /mnt/boot/config.txt` replace:
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
10. Reboot the pi to make the changes effective `sudo reboot now`
11. Login into the Pi again. Now we're going to shut it down `sudo shutdown now`
12. Wait a few seconds that the pi turns off, a few more seconds... ok now unplug the power
13. Remove the microSD
14. Re-plug the usb-c power cable. (Note: if for any reason you don't have your PI wired and you are relying on a WiFi connection, please have a look at these [docs](/WIFI_CONFIG.md))
15. Wait a few seconds for the pi to boot and ssh into it. (You may need to re-run nmap if your pi has changed ip)
16. Install the "auto_decompress_kernel" script
```bash
cd ~ && git clone --depth 1 https://github.com/speedwing/cardano-staking-pool-edu.git
bash ~/cardano-staking-pool-edu/misc/init-auto_decompress_kernel.sh
```
16. We can now update our Ubuntu to the latest and greatest version
    * `sudo apt-get update && sudo apt-get dist-upgrade` (this is going to take a while, see note below in case of errors)
    
> **NOTE**: in case you get an error during the `sudo apt-get update && sudo apt-get dist-upgrade` it could be due to the 
> fact that "important automatic updates" are run automatically. Wait a few minutes, and try again
   
Congratulations, your Raspberry PI is now ready to build the `cardano-node` binary.
