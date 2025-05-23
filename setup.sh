#!/usr/bin/bash

# prepare environment for graylog
sudo apt install -y pwgen
if [ ! -f .env ]; then
    echo ".env file does not exist. creating..."
    cp .env.example .env
    sed -i "s/^GRAYLOG_PASSWORD_SECRET=\"\"/GRAYLOG_PASSWORD_SECRET=\"$(pwgen -N 1 -s 96)\"/" .env
    # set the graylog password
    read -p "Set a password for Graylog: " GRAYLOG_PASSWORD
    echo
    GRAYLOG_PASSWORD_HASH=$(echo -n "$GRAYLOG_PASSWORD" | shasum -a 256 | awk '{print $1}')
    sed -i "s/^GRAYLOG_ROOT_PASSWORD_SHA2=\"\"/GRAYLOG_ROOT_PASSWORD_SHA2=\"$GRAYLOG_PASSWORD_HASH\"/" .env
fi

if grep -q 'GRAYLOG_PASSWORD_SECRET=""' .env || grep -q 'GRAYLOG_ROOT_PASSWORD_SHA2=""' .env; then
    echo "Please fill the .env file before proceeding."
    if grep -q 'GRAYLOG_PASSWORD_SECRET=""' .env; then
        echo "use 'pwgen -N 1 -s 96' to generate a value for GRAYLOG_PASSWORD_SECRET"
    fi
    if grep -q 'GRAYLOG_ROOT_PASSWORD_SHA2=""' .env; then
        echo "use 'echo -n yourpassword | shasum -a 256' to generate a value for GRAYLOG_ROOT_PASSWORD_SHA2"
    fi
    exit 1
fi

if [ "$(sysctl -n vm.max_map_count)" -lt 262144 ]; then
    if ! grep -q "vm.max_map_count" /etc/sysctl.conf; then
        sudo bash -c 'printf "\nvm.max_map_count=262144\n" >>/etc/sysctl.conf'
    else
        sudo sed -i "s/^vm\.max_map_count=.*/vm.max_map_count=262144/" /etc/sysctl.conf
    fi
    sudo sysctl -p
fi

# install docker and docker compose
if ! docker compose version >/dev/null 2>&1; then
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker.io docker-compose-plugin
fi
if ! id -nG | grep -qw docker; then
    sudo usermod -aG docker $USER
    echo "docker has been installed and the current user was added to the docker group. please restart the session for the changes to take effect"
fi

echo "SETUP COMPLETE"