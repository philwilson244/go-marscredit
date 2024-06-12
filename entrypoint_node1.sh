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

# Ensure directories exist
mkdir -p /data/geth/ethash
mkdir -p /data/.ethash

# Initialize Geth with the genesis file (only needed for first run)
if [ ! -d "/data/geth/chaindata" ]; then
    geth init /app/genesis.json --datadir /data
fi

# Create a password file
echo "marscredit011" > /data/passwordfile

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
    --password /data/passwordfile \
    --allow-insecure-unlock \
    --verbosity 6 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover \
    --nodekey /data/geth/nodekey \
    --ethash.dagdir /data/.ethash &


# Wait indefinitely so the script doesn't exit
wait
