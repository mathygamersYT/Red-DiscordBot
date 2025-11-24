FROM python:3.11-slim

LABEL author="Cog-Creators" maintainer="Cog-Creators"

# Usamos SOLO este bloque corregido con mkdir
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    openjdk-17-jre-headless \
    wget \
    procps && \
    rm -rf /var/lib/apt/lists/*

# (Aquí abajo debería seguir el resto de tu Dockerfile original si había más cosas, 
# como crear usuarios o copiar archivos. Si no había más, déjalo así).
WORKDIR /app
COPY . .
# Asegúrate de que el entrypoint tenga permisos de ejecución
RUN chmod +x entrypoint.sh

USER 1000:1000
CMD ["/bin/bash", "entrypoint.sh"]
