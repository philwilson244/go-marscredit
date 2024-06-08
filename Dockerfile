#FROM golang:1.17-alpine AS build

# Use the official Docker DinD image
FROM docker:latest

# Install necessary packages with verbose logging
RUN apk --no-cache --verbose add make gcc musl-dev linux-headers git || { echo 'Package installation failed'; exit 1; }

# Clone the Geth repository
RUN git clone https://github.com/ethereum/go-ethereum.git /go-ethereum || { echo 'Git clone failed'; exit 1; }

# Set the working directory
WORKDIR /go-ethereum

# Checkout the desired version
RUN git checkout v1.10.25 || { echo 'Git checkout failed'; exit 1; }

# Build Geth
RUN make geth || { echo 'Geth build failed'; exit 1; }

# Use a minimal image for the final build
FROM alpine:latest

# Copy the Geth binary from the build stage
COPY --from=build /go-ethereum/build/bin/geth /usr/local/bin/geth

# Copy the genesis file
COPY genesis.json /genesis.json

# Copy the entrypoint scripts
COPY entrypoint_node1.sh /entrypoint_node1.sh
COPY entrypoint_node2.sh /entrypoint_node2.sh
COPY entrypoint_node3.sh /entrypoint_node3.sh

# Make the scripts executable
RUN chmod +x /entrypoint_node1.sh /entrypoint_node2.sh /entrypoint_node3.sh

# Create the data directory
RUN mkdir -p /data

# Expose necessary ports
EXPOSE 8541
EXPOSE 8542
EXPOSE 8543
EXPOSE 8544
EXPOSE 8545
EXPOSE 8546

# Use the output_enode script to log the enode URL
CMD ["/entrypoint_${NODE_ID}.sh"]
