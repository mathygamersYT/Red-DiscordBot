FROM python:3.11-slim-bookworm

LABEL author="MathyGamers" maintainer="MathyGamers"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    default-jre-headless \
    wget \
    curl \
    ca-certificates \
    procps \
    dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Instalamos RedBot
RUN pip install --no-cache-dir Red-DiscordBot

# Configuración del usuario 'container' para Pelican
RUN useradd -d /home/container -m container
ENV USER=container HOME=/home/container
ENV PATH="/home/container/.local/bin:${PATH}"

WORKDIR /home/container

COPY . .

USER root
RUN chown -R container:container /home/container && \
    dos2unix entrypoint.sh && \
    chmod +x entrypoint.sh

USER container


ENTRYPOINT ["/bin/bash", "/home/container/entrypoint.sh"]
