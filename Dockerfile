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

# Copy the genesis file
COPY genesis.json /app/genesis.json

# Copy the entrypoint scripts
COPY entrypoint_node1.sh /app/entrypoint_node1.sh

COPY keystore/* /app/data/keystore
COPY passwordfile /app/data/passwordfile
COPY nodekey /app/data/geth/nodekey

# Make the script executable
RUN chmod +x /app/entrypoint_node1.sh

# Create app directory
WORKDIR /app

# Expose necessary ports
EXPOSE 8541 30303

# Use the entrypoint script
CMD ["/bin/sh", "-c", "sh /app/entrypoint_${NODE_ID}.sh"]
