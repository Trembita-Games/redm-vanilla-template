#!/bin/bash

cd "$(dirname "$0")/.."

if [ ! -f "server/FXServer" ]; then
    echo "[ERROR] FXServer executable is missing."
    echo "Please download and extract FXServer artifacts into the server directory."
    exit 1
fi

./server/FXServer +exec server.cfg