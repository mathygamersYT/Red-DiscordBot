#!/bin/bash
cd /home/container

# Make internal docker spinup wait until processes are correctly started
sleep 1

# Check if we are installing or running
if [ ! -d "redbot" ]; then
    echo "Red-DiscordBot not found, installing..."
    # We assume requirements are installed via the egg's install script or pre-baked image
    # But for safety, we can try to install if requirements.txt exists
    if [ -f "requirements.txt" ]; then
        pip install -U -r requirements.txt
    fi
fi

# Run the bot
# We use the environment variables passed by Pterodactyl
# RED_TOKEN, PREFIX, OWNER_ID, INSTANCE_NAME

if [ -z "$INSTANCE_NAME" ]; then
    INSTANCE_NAME="red"
fi

# Check if instance exists, if not set it up
if ! redbot-setup --list | grep -q "$INSTANCE_NAME"; then
    echo "Setting up instance $INSTANCE_NAME..."
    # Non-interactive setup
    # We need to determine data path. Pterodactyl usually mounts /home/container as the persistent storage.
    # Red's default data path is usually in a platform specific location, but we can force it.
    
    # However, redbot-setup --no-prompt requires --instance-name, --data-path (optional but good to be explicit)
    # and --backend (default json).
    
    # Let's try to set it up in /home/container/data
    mkdir -p /home/container/data
    
    redbot-setup --no-prompt --instance-name "$INSTANCE_NAME" --data-path "/home/container/data" --backend json
fi

# If token and prefix are provided via env vars, we might need to set them if not already set
# But Red reads from config. 
# If this is the first run, we can pass them to redbot command if supported, or rely on the user to set them via config.
# Wait, redbot command supports --token and --prefix flags.

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
