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
    procps && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir Red-DiscordBot


RUN useradd -d /home/container -m container
USER container
ENV USER=container HOME=/home/container
ENV PATH="/home/container/.local/bin:${PATH}"
ENV JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true"

WORKDIR /home/container

COPY . .


ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
