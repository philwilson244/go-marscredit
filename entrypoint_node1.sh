#!/bin/sh

echo "Starting Node 1"

# Initialize Geth with the genesis file
geth init /app/genesis.json --datadir /app/data

# Create a password file
echo "marscredit011" > /app/data/passwordfile

# Start Geth and enable mining
exec geth --datadir /app/data \
    --syncmode "full" \
    --http \
    --http.port 8541 \
    --http.api personal,eth,net,web3,miner \
    --http.vhosts=* \
    --http.corsdomain=* \
    --networkid 110110 \
    --ws \
    --ws.port 8544 \
    --mine \
    --miner.threads=1 \
    --miner.etherbase 0x4d582929B14fb9534AE0A4ABd821ab5FAeb69B67 \
    --unlock 0x4d582929B14fb9534AE0A4ABd821ab5FAeb69B67 \
    --password /app/data/passwordfile \
    --allow-insecure-unlock \
    --verbosity 5 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
