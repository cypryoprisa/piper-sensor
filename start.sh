#!/usr/bin/bash

echo "       ♪ ♫  ♪"
echo "       ( )"
echo "      <|===>"
echo "      / \\"
echo "     /___\\     <-- The Piper Sensor"
echo "    |     |"
echo ""
echo "          🐛   🦠   🐞   💣   👾   🧟‍♂️"

# backup old pihole logs so they wont't be sent again to graylog
LOG_FILE="var-log-pihole/pihole.log"
if [ -f "$LOG_FILE" ]; then
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    mv "$LOG_FILE" "${LOG_FILE}_${TIMESTAMP}"
fi

docker compose up -d