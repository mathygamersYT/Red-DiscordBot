FROM python:3.11-slim

LABEL maintainer="mathygamersYT"
LABEL description="Red-DiscordBot para Pelican Panel"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

# Actualizar e instalar dependencias básicas
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        git \
        build-essential \
        wget \
        curl \
        procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar Java 17 para Lavalink
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verificar Java
RUN java -version

# Instalar Red-DiscordBot
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir Red-DiscordBot

# Crear directorios
RUN mkdir -p /home/container/data && \
    chmod -R 755 /home/container

# Script de inicio simple
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /home/container
EXPOSE 2333

ENTRYPOINT ["/entrypoint.sh"]
