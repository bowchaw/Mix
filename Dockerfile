# Base Image
FROM ghcr.io/missemily2022/mirrorx:heroku

# Home Dir
WORKDIR /app/

RUN apt-get -qq update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y tzdata aria2 python3 python3-pip \
    locales python3-lxml \
    curl pv jq mkvtoolnix mediainfo \
    wget git zip unzip \
    p7zip-full p7zip-rar

#gdrive setupz
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz && tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz && rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/julia362x/gdrive && echo "KGdkcml2ZSB1cGxvYWQgIiQxIikgMj4gL2Rldi9udWxsIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && \
chmod +x /usr/local/bin/gup

# Mirror Bot files and requirements
COPY . .
RUN mv bin/extract /usr/local/bin && \
    mv bin/pextract /usr/local/bin && \
    chmod +x /usr/local/bin/extract && \
    chmod +x /usr/local/bin/pextract && \
    wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht.dat -O /app/dht.dat && \
    wget -q https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat -O /app/dht6.dat && \
    mkdir -p /root/ && \
    pip3 -q install --no-cache-dir -r requirements.txt

# Script Which Starts the Bot
CMD ["MirrorX"]

