FROM golang:latest

MAINTAINER BaseBoxOrg anybucket@gmail.com

EXPOSE 8080

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -q -y && \
    apt-get dist-upgrade -q -y && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 923F6CA9 && \
    echo "deb http://ppa.launchpad.net/ethereum/ethereum-dev/ubuntu wily main" | tee -a /etc/apt/sources.list.d/ethereum.list && \
    apt-get update && \
    apt-get install -q -y geth


# Install required golang tools
RUN go get github.com/ethereum/ethash  && \
    go get github.com/ethereum/go-ethereum/common && \
    go get github.com/goji/httpauth && \
    go get github.com/gorilla/mux && \
    go get github.com/yvasiyarov/gorelic

RUN mkdir /app 

ADD . /app/ 

WORKDIR /app 

RUN go build -o ether-proxy .

RUN useradd ether-proxy && echo "ether-proxy:ether-proxy" | chpasswd
RUN chown -R ether-proxy:ether-proxy /app
USER ether-proxy

ENTRYPOINT ["/app/ether-proxy"]
CMD [""]
