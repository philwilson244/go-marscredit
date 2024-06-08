#!/bin/sh

echo "Starting Node 1"

# Initialize Geth with the genesis file
geth init /genesis.json

# Create a password file
echo "marscredit011" > /data/passwordfile

# Start Geth and enable mining
exec geth --datadir /data \
    --syncmode "full" \
    --http \
    --http.addr "0.0.0.0" \
    --http.port 8541 \
    --http.api personal,eth,net,web3,miner \
    --http.vhosts=* \
    --http.corsdomain=* \
    --networkid 110110 \
    --ws \
    --ws.addr "0.0.0.0" \
    --ws.port 8544 \
    --mine \
    --miner.threads=1 \
    --miner.etherbase 0xD21602919e81e32A456195e9cE34215Af504535A \
    --unlock 0xD21602919e81e32A456195e9cE34215Af504535A \
    --password /data/passwordfile \
    --allow-insecure-unlock \
    --verbosity 5 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
