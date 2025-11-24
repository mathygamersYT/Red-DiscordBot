FROM python:3.11-slim

# Etiquetas
LABEL maintainer="mathygamersYT"
LABEL description="Red-DiscordBot optimizado para Pelican Panel con soporte completo de Audio/Lavalink"

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    PATH="${JAVA_HOME}/bin:${PATH}"

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    # Java 17 para Lavalink
    openjdk-17-jre-headless \
    # Herramientas de red y diagnóstico
    wget \
    curl \
    netcat-traditional \
    procps \
    # Limpiar cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verificar instalación de Java
RUN java -version

# Instalar Red-DiscordBot y dependencias
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir Red-DiscordBot[all]

# Crear directorios necesarios
RUN mkdir -p /home/container/data/cogs/Audio/logs && \
    chmod -R 755 /home/container

# Crear configuración optimizada de Lavalink
RUN echo 'server:\n\
  port: 2333\n\
  address: 0.0.0.0\n\
\n\
lavalink:\n\
  server:\n\
    password: "youshallnotpass"\n\
    sources:\n\
      youtube: true\n\
      bandcamp: true\n\
      soundcloud: true\n\
      twitch: true\n\
      vimeo: true\n\
      http: true\n\
      local: false\n\
    bufferDurationMs: 400\n\
    frameBufferDurationMs: 1000\n\
    youtubePlaylistLoadLimit: 6\n\
    playerUpdateInterval: 5\n\
    youtubeSearchEnabled: true\n\
    soundcloudSearchEnabled: true\n\
    gc-warnings: true\n\
\n\
metrics:\n\
  prometheus:\n\
    enabled: false\n\
    endpoint: /metrics\n\
\n\
sentry:\n\
  dsn: ""\n\
  environment: ""\n\
\n\
logging:\n\
  file:\n\
    max-history: 7\n\
    max-size: 50MB\n\
  path: ./logs/\n\
  level:\n\
    root: INFO\n\
    lavalink: INFO' > /home/container/data/cogs/Audio/application.yml

# Script de entrada mejorado
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "🔧 Iniciando Red-DiscordBot..."\n\
\n\
# Verificar variables de entorno requeridas\n\
if [ -z "$RED_TOKEN" ]; then\n\
    echo "❌ Error: RED_TOKEN no está configurado"\n\
    echo "Configura tu token en las variables de entorno de Pelican"\n\
    exit 1\n\
fi\n\
\n\
# Configurar instancia si no existe\n\
INSTANCE_NAME="${INSTANCE_NAME:-red}"\n\
OWNER_ID="${OWNER_ID:-}"\n\
PREFIX="${PREFIX:-!}"\n\
\n\
cd /home/container\n\
\n\
# Verificar si la instancia existe\n\
if [ ! -d "/home/container/data/$INSTANCE_NAME" ]; then\n\
    echo "📝 Configurando instancia $INSTANCE_NAME..."\n\
    \n\
    if [ -z "$OWNER_ID" ]; then\n\
        echo "❌ Error: OWNER_ID no está configurado"\n\
        echo "Necesitas configurar tu Discord ID como propietario"\n\
        exit 1\n\
    fi\n\
    \n\
    # Crear configuración automática\n\
    redbot-setup \\\n\
        --instance-name "$INSTANCE_NAME" \\\n\
        --data-path "/home/container/data" \\\n\
        --no-prompt \\\n\
        --token "$RED_TOKEN" \\\n\
        --owner "$OWNER_ID" \\\n\
        --prefix "$PREFIX"\n\
    \n\
    echo "✅ Instancia configurada correctamente"\n\
fi\n\
\n\
# Limpiar procesos de Lavalink zombies\n\
echo "🧹 Limpiando procesos anteriores..."\n\
pkill -9 -f "Lavalink.jar" 2>/dev/null || true\n\
sleep 2\n\
\n\
# Verificar Java\n\
echo "☕ Verificando Java..."\n\
java -version 2>&1 | head -n 1\n\
\n\
# Dar tiempo para que los servicios se estabilicen\n\
echo "⏳ Esperando inicialización..."\n\
sleep 3\n\
\n\
# Iniciar el bot\n\
echo "🚀 Iniciando bot (Instancia: $INSTANCE_NAME)..."\n\
echo ""\n\
exec redbot "$INSTANCE_NAME" --no-prompt\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

# Puerto por defecto para Lavalink
EXPOSE 2333

# Directorio de trabajo
WORKDIR /home/container

# Punto de entrada
ENTRYPOINT ["/entrypoint.sh"]
