#!/bin/sh

echo "LIST BLAKE PUBLIC"
ls /blake/public

echo "LIST PUBLIC"
ls public

# Start the server
exec node server.js
