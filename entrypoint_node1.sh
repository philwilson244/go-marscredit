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

mkdir -p /app/geth/ethash
mkdir -p /app/.ethash
mkdir -p /data/geth/chaindata
mkdir -p /app/keystore

# Clear previous chain data
rm -rf /data/geth/chaindata/*

# Set permissions to ensure Geth can write to the directory
chmod -R 755 /app
chmod -R 755 /data

# Log the contents of the directories
echo "---- Logging contents of /app:"
ls -la /app

echo "---- Logging contents of /data:"
ls -la /data

echo "---- Logging contents of /app/keystore:"
ls -la /app/keystore

echo "---- Checking for specific key file:"
KEY_FILE="/app/keystore/UTC--2024-06-12T21-51-26.975004000Z--c1133a2b8e92a747ebf2a937be3d79c29231f407"
if [ -f "$KEY_FILE" ]; then
    echo "Key file $KEY_FILE exists."
else
    echo "Key file $KEY_FILE does not exist."
    exit 1
fi

# Explicitly log and check permissions of the keystore file
ls -la $KEY_FILE
cat $KEY_FILE



# Initialize Geth with the genesis file
echo "---- Initializing Geth with genesis file"
geth init /app/genesis.json --datadir /data

# echo "Logging contents of /data/geth/chaindata (if exists):"
# if [ -d /data/geth/chaindata ]; then
#     ls -la /data/geth/chaindata
# else
#     echo "chaindata directory does not exist, creating now"
#     mkdir -p /data/geth/chaindata
# fi

# # Initialize Geth with the genesis file (only needed for first run)
# if [ ! -f "/data/geth/chaindata/CURRENT" ]; then
#     echo "Initializing Geth with genesis file"
#     geth init /app/genesis.json --datadir /data
# else
#     echo "chaindata directory exists and is not empty"
# fi

# Start Geth and enable mining
echo "Starting Geth and enabling mining"
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
    --miner.etherbase 0xc1133A2B8E92a747eBF2A937bE3D79c29231f407 \
    --unlock 0xc1133A2B8E92a747eBF2A937bE3D79c29231f407 \
    --password /data/passwordfile \
    --allow-insecure-unlock \
    --verbosity 9 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover \
    --nodekey /data/geth/nodekey \
    --ethash.dagdir /app/.ethash &

# Wait indefinitely so the script doesn't exit
wait
