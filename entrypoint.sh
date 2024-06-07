#!/bin/sh

# Initialize Geth with the genesis file
geth init /genesis.json --datadir /data

# Start Geth
exec geth --datadir /data --http --http.addr 0.0.0.0 --http.port 8545 --http.api personal,eth,net,web3 --networkid 110110