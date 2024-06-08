#!/bin/sh

echo "Starting Node 1"

# Initialize Geth with the genesis file
geth init /genesis.json --datadir /data

# Create a password file
echo "marscredit011" > /data/passwordfile

# Create a new account and capture the address
ACCOUNT_OUTPUT=$(geth account new --datadir /data --password /data/passwordfile)
echo "Account creation output: $ACCOUNT_OUTPUT"
ACCOUNT_ADDRESS=$(echo "$ACCOUNT_OUTPUT" | sed -n 's/.*Public address of the key:   \([^ ]*\).*/\1/p')
KEYFILE=$(echo "$ACCOUNT_OUTPUT" | sed -n 's/.*Path of the secret key file: \(.*\)/\1/p')

# Check if the account was created successfully
if [ -z "$ACCOUNT_ADDRESS" ]; then
  echo "Failed to create a new account."
  exit 1
fi

echo "Account Address: $ACCOUNT_ADDRESS"
echo "Keyfile path: $KEYFILE"

# Extract the private key from the keystore file using Python
PRIVATE_KEY=$(python3 - <<EOF
import json
from eth_account import Account
with open("$KEYFILE") as keyfile:
    encrypted_key = json.load(keyfile)
    private_key = Account.decrypt(encrypted_key, "marscredit011")
    print(private_key.hex())
EOF
)

# Check if the private key was extracted successfully
if [ -z "$PRIVATE_KEY" ]; then
  echo "Failed to extract the private key for the account $ACCOUNT_ADDRESS."
  exit 1
fi

# Log the private key (ensure this log is stored securely)
echo "Private key for $ACCOUNT_ADDRESS: $PRIVATE_KEY"

# Start Geth and enable mining
exec geth --datadir /data \
    --syncmode "full" \
    --http \
    --h
