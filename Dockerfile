# CAMBIO 1: Usamos "bookworm" para asegurar que sea una versión estable de Linux
FROM python:3.11-bookworm

LABEL author="MathyGamers" maintainer="MathyGamers"

# CAMBIO 2: Usamos "default-jre-headless" en vez de una versión numero especifica
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    default-jre-headless \
    wget \
    procps && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Permisos para el script de arranque
RUN chmod +x entrypoint.sh

# Usuario Pterodactyl
USER 1000:1000
CMD ["/bin/bash", "entrypoint.sh"]
