#!/bin/sh
echo "Start?"

rm -rf "public"
ln -s "/blake/public" "public"

# Check if "config" directory exists before creating
if [ ! -d "config" ]; then
    mkdir "config"
else
    echo "config directory already exists. Skipping."
fi

IFS=","
RESOURCES="characters,chats,groups,group chats,User Avatars,worlds,settings.json"

# Loop over resources and create symbolic links
echo "LISTING BLAKE PUBLIC -->"
ls public
echo "LISTING PUBLIC -->"
ls public

# Start the server
exec node server.js
