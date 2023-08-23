#!/bin/sh

if [ ! -e "/blake/public" ]; then
    echo "MOVE TO BLAKE -->"
    cp -r "public" "/blake"
fi

echo "LIST BLAKE PUBLIC"
ls /blake/public

# Initialize missing user files
IFS="," RESOURCES="characters,groups,group chats,chats,User Avatars,worlds"
for R in $RESOURCES; do
  if [ ! -e "config/$R" ]; then
    echo "Resource not found, copying from defaults: $R"
    cp -r "public/$R.default" "config/$R"
  fi
done

if [ ! -e "config/config.conf" ]; then
    echo "Resource not found, copying from defaults: config.conf"
    cp -r "default/config.conf" "config/config.conf"
fi

if [ ! -e "config/settings.json" ]; then
    echo "Resource not found, copying from defaults: settings.json"
    cp -r "default/settings.json" "config/settings.json"
fi

if [ ! -e "config/bg_load.css" ]; then
    echo "Resource not found, copying from defaults: bg_load.css"
    cp -r "default/bg_load.css" "config/bg_load.css"
fi

ls /blake

# Start the server
exec node server.js
