FROM golang:1.17-alpine AS build

# Install necessary packages
RUN apk add --no-cache ca-certificates make gcc musl-dev linux-headers git

# Clone the Geth repository
RUN git clone https://github.com/ethereum/go-ethereum.git /go-ethereum

# Set the working directory
WORKDIR /go-ethereum

# Checkout the desired version
RUN git checkout v1.10.18

# Build Geth
RUN make geth

# Use a minimal image for the final build
FROM alpine:latest

# Install bash
RUN apk add --no-cache bash

# Copy the Geth binary from the build stage
COPY --from=build /go-ethereum/build/bin/geth /usr/local/bin/geth

# Create necessary directories
RUN mkdir -p /data/geth/ethash && mkdir -p /data/.ethash && mkdir -p /data/geth/chaindata && mkdir -p /app/keystore

# Copy the genesis file and other necessary files
COPY genesis.json /app/genesis.json
COPY nodekey /data/geth/nodekey
COPY nodekey2 /app/nodekey2
COPY entrypoint_node1.sh /app/entrypoint_node1.sh
# COPY entrypoint_node2.sh /app/entrypoint_node2.sh
COPY keystore/* /app/keystore
COPY passwordfile /app/passwordfile

# Make the script executable
RUN chmod +x /app/entrypoint_node1.sh
# RUN chmod +x /app/entrypoint_node2.sh

# Create app directory
WORKDIR /app

# Expose necessary ports
EXPOSE 443 30303 30304 8545 8546

# Use the entrypoint script
CMD ["/bin/sh", "-c", "/app/entrypoint_${NODE_ID}.sh"]
