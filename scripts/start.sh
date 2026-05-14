#!/bin/bash

cd "$(dirname "$0")/.."

if [ ! -d "server" ]; then
    echo "[ERROR] FXServer artifacts are missing."
    echo "Please download and extract FXServer artifacts into the server directory."
    exit 1
fi

cd server

./FXServer +exec ../server.cfg