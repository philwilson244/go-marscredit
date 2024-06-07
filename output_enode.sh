#!/bin/sh

# Start Geth in the background
geth --datadir /data --http --http.addr 0.0.0.0 --http.port 8545 --http.api personal,eth,net,web3 --networkid 110110 &
GETH_PID=$!

# Wait for Geth to start
sleep 10

# Output the enode URL
geth attach http://localhost:8545 --exec admin.nodeInfo.enode

# Stop Geth
kill $GETH_PID

# Start Geth normally
exec geth --datadir /data --syncmode "fast" --http --http.addr 0.0.0.0 --http.port 8545 --http.api personal,eth,net,web3 --networkid 110110 --mine --miner.etherbase=0xYourCoinbaseAddress --bootnodes "$BOOTNODES"