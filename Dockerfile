FROM ethereum/client-go:alltools-stable

COPY genesis.json /genesis.json

RUN geth init /genesis.json --datadir /data

CMD ["geth", "--datadir", "/data", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "personal,eth,net,web3", "--networkid", "110110"]