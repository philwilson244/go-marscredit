#!/bin/sh

echo "Starting Node 1"

# Initialize Geth with the genesis file
geth init /genesis.json --datadir /data

# Create a password file
echo "marscredit011" > /data/passwordfile

# Create a new account and capture the address
ACCOUNT_OUTPUT=$(geth account new --datadir /data --password /data/passwordfile)
echo "Account creation output: $ACCOUNT_OUTPUT"
ACCOUNT_ADDRESS=$(echo "$ACCOUNT_OUTPUT" | sed -n 's/.*Address: {\([^}]*\)}.*/\1/p')

# Check if the account was created successfully
if [ -z "$ACCOUNT_ADDRESS" ]; then
  echo "Failed to create a new account."
  exit 1
fi

echo "Account Address: $ACCOUNT_ADDRESS"

# Export the private key of the created account
EXPORT_OUTPUT=$(geth account export --datadir /data --password /data/passwordfile $ACCOUNT_ADDRESS)
echo "Export output: $EXPORT_OUTPUT"
PRIVATE_KEY=$(echo "$EXPORT_OUTPUT" | sed -n 's/.*Private key: \(.*\)/\1/p')

# Check if the private key was exported successfully
if [ -z "$PRIVATE_KEY" ]; then
  echo "Failed to export the private key for the account $ACCOUNT_ADDRESS."
  exit 1
fi

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
