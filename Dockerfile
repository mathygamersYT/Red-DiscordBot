FROM python:3.11-bookworm

LABEL author="MathyGamers" maintainer="MathyGamers"

# Instalamos las dependencias del sistema (Java, git, etc.)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    default-jre-headless \
    wget \
    procps && \
    rm -rf /var/lib/apt/lists/*

# --- LA SOLUCIÓN MÁGICA ESTÁ AQUÍ ABAJO ---
# Le decimos a Linux que busque ejecutables en la carpeta del usuario
ENV PATH="/home/container/.local/bin:${PATH}"

WORKDIR /app
COPY . .

# Permisos
RUN chmod +x entrypoint.sh

# Usuario
USER 1000:1000
CMD ["/bin/bash", "entrypoint.sh"]
