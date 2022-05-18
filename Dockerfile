# Base Image
FROM ghcr.io/missemily2022/mirrorx:heroku

# Home Dir
WORKDIR /app/

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
