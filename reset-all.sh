#!/usr/bin/bash

rm -rf .env etc-pihole/ var-log-pihole
docker volume rm piper-sensor_graylog-datanode \
                 piper-sensor_graylog_data \
                 piper-sensor_mongodb_config \
                 piper-sensor_mongodb_data
docker container prune
docker network prune