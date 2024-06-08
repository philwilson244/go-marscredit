#!/bin/sh

echo "Starting Node 1"

# Initialize Geth with the genesis file
geth init /genesis.json --datadir /data

# Create a password file
echo "marscredit011" > /data/passwordfile

# Create a new account and capture the address
ACCOUNT_OUTPUT=$(geth account new --datadir /data --password /data/passwordfile)
ACCOUNT_ADDRESS=$(echo "$ACCOUNT_OUTPUT" | awk -F'[{}]' '{print $2}')
KEYFILE=$(echo "$ACCOUNT_OUTPUT" | grep -oP '.*keystore.*')

# Export the private key of the created account
PRIVATE_KEY=$(geth account export --datadir /data --password /data/passwordfile $ACCOUNT_ADDRESS | grep -oP '(?<=Private key: ).*')

# Log the private key (ensure this log is stored securely)
echo "Private key for $ACCOUNT_ADDRESS: $PRIVATE_KEY"

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
    --miner.etherbase $ACCOUNT_ADDRESS \
    --unlock $ACCOUNT_ADDRESS \
    --password /data/passwordfile \
    --allow-insecure-unlock \
    --verbosity 5 \
    --maxpeers 50 \
    --cache 2048 \
    --nodiscover
