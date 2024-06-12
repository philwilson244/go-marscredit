#!/bin/sh

echo "Starting Node 1"

# Function to handle shutdown
shutdown() {
    echo "Shutting down Geth..."
    pkill geth
    exit 0
}

# Trap SIGTERM signal (sent by Railway when stopping the container)
trap shutdown SIGTERM

# Ensure directories exist and handle existing file issue
if [ -f /app/keystore ]; then
    rm /app/keystore
fi

mkdir -p /app/geth/ethash
mkdir -p /app/.ethash
mkdir -p /app/keystore
mkdir -p /data/geth/chaindata

# Set permissions to ensure Geth can write to the directory
chmod -R 755 /app
chmod -R 755 /data

# Log the contents of the directories
echo "Logging contents of /app:"
ls -la /app

echo "Logging contents of /data:"
ls -la /data

echo "Logging contents of /app/keystore:"
ls -la /app/keystore

echo "Logging contents of /data/geth/chaindata (if exists):"
if [ -d /data/geth/chaindata ]; then
    ls -la /data/geth/chaindata
else
    echo "chaindata directory does not exist, creating now"
    mkdir -p /data/geth/chaindata
fi

# Initialize Geth with the genesis file (only needed for first run)
if [ ! -f "/data/geth/chaindata/CURRENT" ]; then
    echo "Initializing Geth with genesis file"
    geth init /app/genesis.json --datadir /data
else
    echo "chaindata directory exists and is not empty"
fi

# Check if the password file exists
if [ ! -f "/app/passwordfile" ]; then
    echo "Password file not found!"
    exit 1
fi

# Check if the key file exists in the keystore
if [ -z "$(ls -A /app/keystore)" ]; then
    echo "Keystore directory is empty!"
    exit 1
fi

# Start Geth and enable mining
geth --datadir /data \
    --syncmode "full" \
    --http \
    --http.port 8541 \
    --http.api personal,eth,net,web3,miner \
    --http.vhosts=* \
    --http.corsdomain=* \
    --networkid 110110 \
    --ws \
    --ws.port 8541 \
    --mine \
    --miner.threads=1 \
    --miner.etherbase 0x4d582929B14fb9534AE0A4ABd821ab5FAeb69B67 \
    --unlock 0x4d582929B14fb9534AE0A4ABd821ab5FAeb69B67 \
    --password /app/passwordfile \
    --allow-insecure-unlock \
    --verbosity 6 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover \
    --nodekey /data/geth/nodekey \
    --ethash.dagdir /app/.ethash &

# Wait indefinitely so the script doesn't exit
wait
