#!/bin/sh
set -e

echo "Symlinking data dir"
mkdir -p /share/eufy-ha-mqtt-bridge/data
rm -rfv /app/data
ln -s /share/eufy-ha-mqtt-bridge/data /app # symlink data mount from share 

echo "exporting environment vars form options file"
echo '# Generated by homeassistant, do not edit!' > /app/data/config.yml
echo '# Edit configuration only at the add-on!' >> /app/data/config.yml
/app/node_modules/.bin/json2yml /data/options.json >> /app/data/config.yml

echo 'patching console log level'
sed -i "s/level: process.env.NODE_ENV === 'production' ? 'error' : 'debug'\,/level: 'info',/" /app/index.js

echo "starting original stuff..."
exec npm run start