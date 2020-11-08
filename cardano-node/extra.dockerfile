FROM speedwing/cardano-node:1.21.1-3

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq curl vim \
    && rm -rf /var/lib/apt/lists/*

COPY bin/* /usr/local/bin/
