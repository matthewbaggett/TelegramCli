FROM ham8/docker-base:x86_64

RUN apt-get update && apt-get install -yq \
    libreadline-dev \
    libconfig-dev \
    libssl-dev \
    lua5.2 \
    liblua5.2-dev \
    libevent-dev \
    libjansson-dev \
    libpython-dev \
    make \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN git clone https://github.com/vysheng/tg.git /tg && cd /tg && git submodule update --init --recursive
RUN ls /tg -lah
RUN cd /tg && ./configure && make

RUN mkdir /app
WORKDIR /app
ADD . /app

ENV PATH /tg/bin/:$PATH

EXPOSE 9999

ENTRYPOINT ["telegram-cli", "-d", "--tcp-port", "9999", "--accept-any-tcp", "--json", "--sync-from-start"]
