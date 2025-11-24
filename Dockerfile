
FROM python:3.11

LABEL author="MathyGamers" maintainer="MathyGamers"


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    build-essential \
    openjdk-17-jre-headless \
    wget \
    procps && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .


RUN chmod +x entrypoint.sh


USER 1000:1000
CMD ["/bin/bash", "entrypoint.sh"]
