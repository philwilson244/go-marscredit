FROM golang:1.17-alpine AS build

RUN apk add --no-cache make gcc musl-dev linux-headers git

RUN git clone https://github.com/ethereum/go-ethereum.git /go-ethereum

WORKDIR /go-ethereum

RUN git checkout v1.13.6

RUN make geth

FROM alpine:latest

COPY --from=build /go-ethereum/build/bin/geth /usr/local/bin/geth

COPY genesis.json /genesis.json

RUN mkdir -p /data

RUN geth init /genesis.json --datadir /data

CMD ["geth", "--datadir", "/data", "--http", "--http.addr", "0.0.0.0", "--http.port", "8545", "--http.api", "personal,eth,net,web3", "--networkid", "110110"]