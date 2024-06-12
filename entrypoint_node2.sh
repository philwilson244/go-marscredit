#!/bin/sh

echo "Starting Node 2"

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
    --ws.port 8541 \
    --mine \
    --miner.etherbase 0xD21602919e81e32A456195e9cE34215Af504535A \
    --bootnodes "enode://7dd435aef0596d6cc6d5b51144211cbbb5b8c99240ab481f636ed73e2297ad96b5c6495be5bac7913fda12ad5caa5c6cea902a96422916ab29b7a9277b75c57f@node1.marscredit.xyz:443?discport=0" \
    --allow-insecure-unlock \
    --verbosity 6 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
