#!/bin/sh

echo "Starting Node 2"

# Start Geth and enable mining
exec geth --datadir /app/data \
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
    --bootnodes "enode://41cb4f04ac043653e60319939ffe266d8d8470829f1a433a2d6b11839888d2b32bd0e66aba812d4ac93a271e4e7418f858fe06f7a32e0d7f3a0177527f91a6c0@node1.marscredit.xyz:8541?discport=0" \
    --allow-insecure-unlock \
    --verbosity 5 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
