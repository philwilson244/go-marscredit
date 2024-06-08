#!/bin/sh

echo "Starting Node 2"

mkdir -p /data

# Start Geth and enable mining
exec geth --datadir /data \
    --syncmode "full" \
    --http \
    --http.addr 0.0.0.0 \
    --http.port 8542 \
    --http.api personal,eth,net,web3,miner \
    --http.vhosts=* \
    --http.corsdomain=* \
    --networkid 110110 \
    --ws \
    --ws.addr "0.0.0.0" \
    --ws.port 8545 \
    --mine \
    --miner.etherbase 0xD21602919e81e32A456195e9cE34215Af504535A \
    --bootnodes "enode://03646ab7a779c22877fd0fea851b7ba73a0d6f0771d0b103d14f15bb333b9789c65c9094743bcd96be43e59e3e080e66ad2e463c17392f1ecf980b3bdd8e028e@node1.marscredit.xyz:8541?discport=0" \
    --allow-insecure-unlock \
    --verbosity 5 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
