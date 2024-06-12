#!/bin/sh

echo "Starting Node 2"

# Start Geth and enable mining
exec geth --datadir /data \
    --keystore /app/keystore \
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
    --bootnodes "enode://fc2c53ecb705b9b736c0c43d2c52377699e0bc5ce5ef0cc1fd72e680b7f385f8109a305d0ab7d5e9e691152d921b93521ffd6c1b21484bc28984bb93a72d3092@node1.marscredit.xyz:443?discport=0" \
    --allow-insecure-unlock \
    --verbosity 6 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
