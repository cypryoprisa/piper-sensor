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
* prepare a `.env` file with environment variables for [Graylog](https://graylog.org/);
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

On the Graylog web page, after you have successfully logged in with the temporary password:
* press the *Create CA* button;
* press the *Create policy* button (you can leave the default options)
* press *Provision certificate and continue* (this operation may take some time)
* press the *Resume startup* button

After these steps, use your permanent password (the one you typed when running the setup script) to log in to the Graylog dashboard (`http://<PIPER_IP>:9000`).

In the next step, you will create a new input to receive logs from Pi-hole. Click on the *System* menu in the Graylog dashboard, then select *Inputs*. From the *Select input* dropdown list select *GELF UDP*, then press the "Launch new input" button. In the settings window, give the input a `Title` (like `pihole`) and make sure the `Port` is set to `12201`, then press `Launch Input`.

To test the setup, open a terminal on your local machine and search for a domain that should be blocked using the Raspberry Pi as a DNS server:

```
nslookup allblock.net <PIPER_IP>
```

If the result of the DNS query is the address `0.0.0.0`, it means that the suspicious domain was successfully blocked. In the Graylog dashboard, press the Search button (or refresh if you are already at the Search page) and you should see an event containing the text `gravity blocked allblock.net`.

## Setting the PIper Sensor as a DNS server
To fully benefit from the PIper Sensor, its IP address (`<PIPER_IP>`) must be used as a DNS server. 

It is recommended to protect the whole network, by modifying the router configuration to use `<PIPER_IP>` as a DNS server. This configuration differs from router to router and should only be performed by a system administrator.

If the first option is not possible, the DNS server can be set individually for a couple of test machines. In Windows, go to *Settings* -> *Network & Internet* -> *Change adapter options*, right click on the active network adapter, click on *Properties*, select *Internet Protocol Version 4 (TCP/IPv4)*, click *Properties*, than use `<PIPER_IP>` as *Preferred DNS server* (make sure to use the actual IP address of the Rapsberry Pi that runs PIper).

## Subsequent runs and updates
After the initial setup, PIper should run normally and restart automatically when the Raspberry Pi restarts. The Graylog dashboard should be available at `http://<PIPER_IP>:9000`.

To stop PIper, open a terminal on the Raspberry Pi (locally or using SSH), navigate to the `piper-sensor` directory, the run the `./stop.sh` script.

To update PIper, first stop it, then run `git pull` in the `piper-sensor` directory. After it has been updated, run `./start.sh` again to start it.

To reset all the configurations and logs, use the `./reset-all.sh` script. Warning: this will erase everything and you will need to redo all the steps from the *First run* section.

