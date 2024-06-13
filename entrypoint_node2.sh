#!/bin/sh

echo "Starting Node 2"

# Function to handle shutdown
shutdown() {
    echo "Shutting down Geth gracefully..."
    pkill -SIGTERM geth
    wait $!
    echo "Geth has been shut down."
    exit 0
}

# Trap SIGTERM signal (sent by Railway when stopping the container)
trap shutdown SIGTERM

mkdir -p /app/geth/ethash
mkdir -p /data/.ethash
mkdir -p /data/geth/chaindata

# Set permissions to ensure Geth can write to the directory
chmod -R 755 /app
chmod -R 755 /data

# Log the contents of the directories
echo "---- Logging contents of /app:"
ls -la /app

echo "---- Logging contents of /data:"
ls -la /data

echo "Logging contents of /data/geth/chaindata (if exists):"
if [ -d /data/geth/chaindata ]; then
    ls -la /data/geth/chaindata
else
    echo "chaindata directory does not exist, creating now"
    mkdir -p /data/geth/chaindata
fi

# Generate nodekey if not present
echo "Checking for nodekey..."
if [ ! -f "/app/nodekey2" ]; then
    echo "Generating new nodekey..."
    bootnode -genkey /app/nodekey2
else
    echo "nodekey2 file exists."
fi

# Log the contents of the nodekey
echo "Logging contents of /app/nodekey2 (if exists):"
if [ -f /app/nodekey2 ]; then
    ls -la /app/nodekey2
fi

# Start Geth and enable mining
echo "Starting Geth on node2 and enabling mining"
exec geth --datadir /data \
    --syncmode "full" \
    --http \
    --http.addr "0.0.0.0" \
    --http.port 8541 \
    --http.api personal,eth,net,web3,miner \
    --http.vhosts=* \
    --http.corsdomain=* \
    --networkid 110110 \
    --ws.addr "0.0.0.0" \
    --ws \
    --ws.port 8541 \
    --mine \
    --miner.threads=1 \
    --miner.etherbase 0xc1133A2B8E92a747eBF2A937bE3D79c29231f407 \
    --bootnodes "enode://fc2c53ecb705b9b736c0c43d2c52377699e0bc5ce5ef0cc1fd72e680b7f385f8109a305d0ab7d5e9e691152d921b93521ffd6c1b21484bc28984bb93a72d3092@node1.marscredit.xyz:443" \
    --allow-insecure-unlock \
    --verbosity 6 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover \
    --nodekey /app/nodekey2 \
    --ethash.dagdir /data/.ethash &
    
# Wait indefinitely so the script doesn't exit
wait
