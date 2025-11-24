FROM python:3.11-slim

# Etiquetas
LABEL maintainer="mathygamersYT"
LABEL description="Red-DiscordBot optimizado para Pelican Panel con soporte completo de Audio/Lavalink"

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    PATH="${JAVA_HOME}/bin:${PATH}"

# Instalar dependencias del sistema en múltiples pasos para mejor diagnóstico
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    wget \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Instalar Java 17 (separado para evitar conflictos)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Instalar herramientas de red (netcat puede no estar disponible en slim)
RUN apt-get update && apt-get install -y --no-install-recommends \
    netcat-openbsd \
    net-tools \
    && rm -rf /var/lib/apt/lists/* || \
    echo "Algunas herramientas de red no disponibles, continuando..."

# Verificar instalación de Java
RUN java -version

# Actualizar pip y instalar Red-DiscordBot
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir Red-DiscordBot[all]

# Crear directorios necesarios
RUN mkdir -p /home/container/data/cogs/Audio/logs && \
    chmod -R 755 /home/container

# Crear configuración optimizada de Lavalink
RUN cat > /home/container/data/cogs/Audio/application.yml << 'EOF'
server:
  port: 2333
  address: 0.0.0.0

lavalink:
  server:
    password: "youshallnotpass"
    sources:
      youtube: true
      bandcamp: true
      soundcloud: true
      twitch: true
      vimeo: true
      http: true
      local: false
    bufferDurationMs: 400
    frameBufferDurationMs: 1000
    youtubePlaylistLoadLimit: 6
    playerUpdateInterval: 5
    youtubeSearchEnabled: true
    soundcloudSearchEnabled: true
    gc-warnings: true

metrics:
  prometheus:
    enabled: false
    endpoint: /metrics

sentry:
  dsn: ""
  environment: ""

logging:
  file:
    max-history: 7
    max-size: 50MB
  path: ./logs/
  level:
    root: INFO
    lavalink: INFO
EOF

# Script de entrada mejorado
RUN cat > /entrypoint.sh << 'EOFSCRIPT'
#!/bin/bash
set -e

echo "🔧 Iniciando Red-DiscordBot..."

# Verificar variables de entorno requeridas
if [ -z "$RED_TOKEN" ]; then
    echo "❌ Error: RED_TOKEN no está configurado"
    echo "Configura tu token en las variables de entorno de Pelican"
    exit 1
fi

# Configurar instancia si no existe
INSTANCE_NAME="${INSTANCE_NAME:-red}"
OWNER_ID="${OWNER_ID:-}"
PREFIX="${PREFIX:-!}"

cd /home/container

# Verificar si la instancia existe
if [ ! -d "/home/container/data/$INSTANCE_NAME" ]; then
    echo "📝 Configurando instancia $INSTANCE_NAME..."
    
    if [ -z "$OWNER_ID" ]; then
        echo "❌ Error: OWNER_ID no está configurado"
        echo "Necesitas configurar tu Discord ID como propietario"
        exit 1
    fi
    
    # Crear configuración automática
    redbot-setup \
        --instance-name "$INSTANCE_NAME" \
        --data-path "/home/container/data" \
        --no-prompt \
        --token "$RED_TOKEN" \
        --owner "$OWNER_ID" \
        --prefix "$PREFIX"
    
    echo "✅ Instancia configurada correctamente"
fi

# Limpiar procesos de Lavalink zombies
echo "🧹 Limpiando procesos anteriores..."
pkill -9 -f "Lavalink.jar" 2>/dev/null || true
sleep 2

# Verificar Java
echo "☕ Verificando Java..."
java -version 2>&1 | head -n 1 || echo "⚠️ Java no disponible (necesario para Audio local)"

# Dar tiempo para que los servicios se estabilicen
echo "⏳ Esperando inicialización..."
sleep 5

# Iniciar el bot
echo "🚀 Iniciando bot (Instancia: $INSTANCE_NAME)..."
echo ""
exec redbot "$INSTANCE_NAME" --no-prompt
EOFSCRIPT

# Hacer el script ejecutable
RUN chmod +x /entrypoint.sh

# Puerto por defecto para Lavalink
EXPOSE 2333

# Directorio de trabajo
WORKDIR /home/container

# Punto de entrada
ENTRYPOINT ["/entrypoint.sh"]
