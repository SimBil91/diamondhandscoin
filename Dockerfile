FROM ubuntu:18.04
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /diamondhandscoin
#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev nano
#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev
#upnp
RUN apt-get install -y libminiupnpc-dev
#ZMQ
RUN apt-get install -y libzmq3-dev
#build diamondhandscoin source
COPY . /diamondhandscoin
RUN ./autogen.sh
RUN ./configure
RUN make -j4
RUN make install
RUN make clean
RUN rm -rf /var/lib/apt/lists/*
#open service port
EXPOSE 6969 19666 12345
CMD ["diamondhandscoind", "--printtoconsole"]
