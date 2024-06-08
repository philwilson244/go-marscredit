#!/bin/sh

echo "Starting Node 3"

# Initialize Geth with the genesis file
geth init /genesis.json

# Start Geth and enable mining
exec geth --datadir /data --syncmode "full" --http --http.addr 0.0.0.0 --http.port 8543 --http.api personal,eth,net,web3 --http.vhosts=* --http.corsdomain=* --networkid 110110 --ws --ws.addr "0.0.0.0" --ws.port 8546 --mine --miner.etherbase=0xD21602919e81e32A456195e9cE34215Af504535A --bootnodes "$BOOTNODES"  --allow-insecure-unlock --verbosity 5 --maxpeers 50 --cache 2048 --nodiscover