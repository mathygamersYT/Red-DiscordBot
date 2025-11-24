FROM python:3.11-slim

LABEL author="Cog-Creators" maintainer="Cog-Creators"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    openjdk-17-jre-headless \
    wget \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -d /home/container -m container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
