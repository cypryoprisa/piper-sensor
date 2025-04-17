#!/usr/bin/bash

echo "WARNING: This action will erase all configuration and logs."
read -p "Type 'yes' to continue: " user_input

if [[ "$user_input" != "yes" ]]; then
    echo "Aborted. You did not type 'yes'."
    exit 1
fi

rm -rf .env etc-pihole/ var-log-pihole
docker volume rm piper-sensor_graylog-datanode \
                 piper-sensor_graylog_data \
                 piper-sensor_mongodb_config \
                 piper-sensor_mongodb_data
docker container prune -f
docker network prune -f