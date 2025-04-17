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

# replace the default pihole adlists
DEST_DIR="etc-pihole"
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
fi
cp -f adlists.list "$DEST_DIR/adlists.list"

docker compose up -d