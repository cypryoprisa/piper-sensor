# The PIper Sensor

To deploy the PIper Sensor on a Raspberry Pi, follow the steps below.

## Raspberry Pi OS installation
Install [Raspberry Pi OS](https://www.raspberrypi.com/software/) on the SD card using the Raspberry Pi Imager.

Connect a keyboard, mouse and HDMI display to the Raspberry Pi and turn it on.

Set a username (for example `admin`) and a strong password.

Connect the Raspberry Pi to the network (Ethernet or Wi-Fi) and note its IP address. From now on, we will refer to this address as `<PIPER_IP>`.

Optionally, enable SSH access to it:
* From the Raspberry Pi desktop, click the menu button, then navigate to *Preferences* -> *Raspberry Pi Configuration*, click on the *Interfaces* tab and enable the *SSH* option.
* Copy your public SSH key from your computer to the Raspberry Pi using the `ssh-copy-id` command:
```ssh-copy-id -i ~/.ssh/id_rsa.pub admin@<PIPER_IP>```.

## Setting up the PIper Sensor
Open a terminal on Raspberry Pi, either by connecting to it directly or using SSH from your local machine (if you enabled SSH access).

Clone this repo, then change the current directory to it (if `git` is not installed, install it first):
```
git clone https://github.com/cypryoprisa/piper-sensor.git
cd piper-sensor
```

