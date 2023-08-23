#!/bin/sh

# Initialize missing user files
IFS="," RESOURCES="characters,groups,group chats,chats,User Avatars,worlds"

echo "CURRENT"
ls
echo "PUBLIC"
ls /public
echo "CONFIG"
ls /config

if [ ! -e "config" ]; then
  mkdir "config"
fi

# Start the server
exec node server.js
