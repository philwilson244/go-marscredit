#!/bin/sh

echo "Starting Node 1"

# Initialize Geth with the genesis file
geth init /genesis.json --datadir /data

# Create a password file
echo "marscredit011" > /data/passwordfile

# Create a new account and capture the address
ACCOUNT_OUTPUT=$(geth account new --datadir /data --password /data/passwordfile)
echo "Account creation output: $ACCOUNT_OUTPUT"
ACCOUNT_ADDRESS=$(echo "$ACCOUNT_OUTPUT" | grep -o '0x[0-9a-fA-F]\{40\}')

# Check if the account was created successfully
if [ -z "$ACCOUNT_ADDRESS" ]; then
  echo "Failed to create a new account."
  exit 1
fi

echo "Account Address: $ACCOUNT_ADDRESS"

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
