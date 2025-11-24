FROM python:3.11-bookworm

LABEL author="MathyGamers" maintainer="MathyGamers"

# 1. Instalamos herramientas del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    default-jre-headless \
    wget \
    procps && \
    rm -rf /var/lib/apt/lists/*

# 2. INSTALAMOS REDBOT AQUÍ DIRECTAMENTE (La Solución Definitiva)
# Esto asegura que el bot exista siempre en el sistema global (/usr/local/bin)
RUN pip install --no-cache-dir Red-DiscordBot

# 3. Configuramos rutas y permisos
ENV PATH="/home/container/.local/bin:${PATH}"
WORKDIR /app
COPY . .
RUN chmod +x entrypoint.sh

# 4. Usuario final
USER 1000:1000
CMD ["/bin/bash", "entrypoint.sh"]
