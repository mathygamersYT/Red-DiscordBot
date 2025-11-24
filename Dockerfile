FROM python:3.11-bookworm


LABEL author="MathyGamers" maintainer="MathyGamers"


RUN apt-get update && \

    apt-get install -y --no-install-recommends \

    git \

    build-essential \

    default-jre-headless \

    wget \

    procps && \

    rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache-dir Red-DiscordBot


RUN chmod -R a+rx /usr/local/lib/python3.11/site-packages


ENV PATH="/home/container/.local/bin:${PATH}"

WORKDIR /app

COPY . .

RUN chmod +x entrypoint.sh


USER 1000:1000

CMD ["/bin/bash", "entrypoint.sh"]
