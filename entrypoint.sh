#!/bin/bash
export PATH=$PATH:/home/container/.local/bin

cd /home/container

sleep 1

if [ ! -d "redbot" ]; then
    echo "Red-DiscordBot not found, installing..."
    if [ -f "requirements.txt" ]; then
        pip install -U -r requirements.txt
    fi
fi

if [ -z "$INSTANCE_NAME" ]; then
    INSTANCE_NAME="red"
fi

if ! redbot-setup --list | grep -q "$INSTANCE_NAME"; then
    echo "Setting up instance $INSTANCE_NAME..."
    mkdir -p /home/container/data
    
    redbot-setup --no-prompt --instance-name "$INSTANCE_NAME" --data-path "/home/container/data" --backend json
fi

CMD_ARGS=""
if [ -n "$RED_TOKEN" ]; then
    CMD_ARGS="$CMD_ARGS --token $RED_TOKEN"
fi

if [ -n "$PREFIX" ]; then
    CMD_ARGS="$CMD_ARGS --prefix $PREFIX"
fi

if [ -n "$OWNER_ID" ]; then
    CMD_ARGS="$CMD_ARGS --owner $OWNER_ID"
fi


if [ -n "$LAVALINK_HOST" ]; then
    echo "External Lavalink Host detected: $LAVALINK_HOST"
fi

echo "Starting Red-DiscordBot..."
# shellcheck disable=SC2086
exec redbot "$INSTANCE_NAME" $CMD_ARGS
