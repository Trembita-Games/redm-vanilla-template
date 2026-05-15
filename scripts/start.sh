#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f "server/FXServer" ]; then
    echo "[ERROR] FXServer executable is missing."
    echo "Please download and extract FXServer artifacts into the server directory."
    exit 1
fi

if [ ! -f "server.cfg" ]; then
    echo "[ERROR] server.cfg was not found in the repository root."
    exit 1
fi

mkdir -p logs

timestamp="$(date +"%Y%m%d-%H%M%S")"
log_file="logs/server-${timestamp}.log"

echo "Starting RedM Vanilla Server"
echo "Root path: $(pwd)"
echo "Log file: ${log_file}"
echo ""

./server/FXServer +exec server.cfg 2>&1 | tee "$log_file"