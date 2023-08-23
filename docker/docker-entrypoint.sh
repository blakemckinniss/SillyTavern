#!/bin/bash

echo "LIST BLAKE PUBLIC"
ls /blake/public

echo "LIST PUBLIC"
ls public

# Check if "public" is not a link or directory before creating a symbolic link
if [ ! -e "public" ] && [ ! -L "public" ]; then
    ln -s "/blake/public" "public"
else
    echo "public already exists. Skipping symbolic link creation."
fi

# Check if "config" directory exists before creating
if [ ! -d "config" ]; then
    mkdir "config"
else
    echo "config directory already exists. Skipping."
fi

IFS=","
RESOURCES="characters,chats,groups,group chats,User Avatars,worlds,settings.json"

# Loop over resources and create symbolic links
for R in $RESOURCES; do 
    # Check if the link or directory doesn't already exist
    if [ ! -e "public/$R" ] && [ ! -L "public/$R" ]; then
        ln -s "../config/$R" "public/$R"
    else
        echo "public/$R already exists. Skipping symbolic link creation."
    fi
done

# Start the server
exec node server.js
