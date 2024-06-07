FROM golang:1.20-alpine AS build

# Install necessary packages
RUN apk add --no-cache make gcc musl-dev linux-headers git

# Clone the Geth repository
RUN git clone https://github.com/ethereum/go-ethereum.git /go-ethereum

# Set the working directory
WORKDIR /go-ethereum

# Checkout the desired version
RUN git checkout v1.13.6

# Build Geth
RUN make geth

# Use a minimal image for the final build
FROM alpine:latest

# Copy the Geth binary from the build stage
COPY --from=build /go-ethereum/build/bin/geth /usr/local/bin/geth

# Copy the genesis file
COPY genesis.json /genesis.json

# Create the data directory
RUN mkdir -p /data

# Initialize Geth with the genesis file
RUN geth init /genesis.json --datadir /data

# Start Geth
CMD ["geth", "--datadir", "/data", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "personal,eth,net,web3", "--networkid", "110110"]