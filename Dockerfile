FROM ethereum/client-go:alltools-stable

# Create necessary directories
RUN mkdir -p /data

# Copy the genesis.json file into the container
COPY genesis.json /genesis.json

# Initialize Geth with the genesis block
RUN geth init --datadir /data /genesis.json

# Run Geth with the specified configurations
CMD ["geth", "--datadir", "/data", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "personal,eth,net,web3", "--networkid", "110110"]