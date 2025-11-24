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

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    openjdk-17-jre-headless \
    wget \
    procps && \
    rm -rf /var/lib/apt/lists/*
