# Update Raspberry PI firmware

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

You can now:
1. Insert the Micro SD in the PI
2. Connect the PI to the lan via the cable (I won't bother setting up the wifi)
3. Power the PI

We have now to discover the IP of the pi.

....

Credentials: pi / raspberry
