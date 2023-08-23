#!/bin/sh
echo "Start?"

#rm -rf "/blake/public"
#cp -r "public" "/blake/public"
rm -rf "public"
ln -s "/blake/public" "public"

# Check if "config" directory exists before creating
if [ ! -d "config" ]; then
    mkdir "config"
else
    echo "config directory already exists. Skipping."
fi

echo "LISTING BLAKE PUBLIC -->"
ls /blake/public
echo "LISTING PUBLIC -->"
ls public

# Start the server
exec node server.js
