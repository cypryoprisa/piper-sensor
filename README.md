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

Run the `setup.sh` script:

```./setup.sh```
This script will:
* prepare a `.env` file with environment variables for Graylog;
* ask you for a Graylog password -- use a strong password, unique for each organisation that this sensor is deployed to;
* install `docker`, `docker compose` and other dependencies;
* add the current user to the `docker` group; for changes to take effect, close the current session and log in again.

## First run
Run the `start.sh` script:

```./start.sh```

This script will use `docker compose` to run multiple containers, including `pihole` and `graylog`. During the first run, the docker images will be downloaded from the internet, so the process might take some time.

After all containers have started, open a browser (on your local machine) and navigate to `http://<PIPER_IP>:9000` to open the Graylog dashboard. The Firefox browser is recommended for this.

During the first run, you must set up the Graylog server. You cannot login with your password yet, a temporary password will be used. To find it, run

```
docker logs piper-sensor-graylog-1
```

At the end of the log message, you should find a text containing the temporary credentials. Use the to login in the browser. The message should look like the one below:

```
Initial configuration is accessible at 0.0.0.0:9000, with username 'admin' and password '<TempPasswd>'.
```

