# External Lavalink Compatibility Walkthrough

I have modified the Red-DiscordBot Pterodactyl setup to support external Lavalink connections.

## Changes Made

### 1. Dockerfile
- Added `ca-certificates` to the installation list. This ensures that the bot can connect to SSL-secured Lavalink nodes (wss://) without certificate errors.

### 2. Pterodactyl Egg (`egg-red-discord-bot.json`)
- Added the following environment variables to the Egg configuration:
    - `LAVALINK_HOST`: Hostname or IP of the external Lavalink node (Optional, default: empty).
    - `LAVALINK_PORT`: Port of the external Lavalink node (Optional, default: empty).
    - `LAVALINK_PASSWORD`: Password for the external Lavalink node (Optional, default: empty).

### 3. Entrypoint Script (`entrypoint.sh`)
- Added a check to print "External Lavalink Host detected: [HOST]" during startup if the variable is set. This helps verify that the variables are being passed correctly to the container.

## How to Use

1.  **Update the Egg**: Import the updated `egg-red-discord-bot.json` into your Pterodactyl panel.
2.  **Rebuild Container**: Reinstall or rebuild the server container to apply the Dockerfile changes (if building from source) or simply restart if using the egg update.
3.  **Configure Variables**: In the server's "Startup" tab, you will now see fields for **Lavalink Host**, **Lavalink Port**, and **Lavalink Password**. Enter your external Lavalink details there.
4.  **Configure Bot**:
    - Start the bot.
    - If you haven't already, you may need to configure the Audio cog to use these details.
    - Note: The environment variables are available in the container, but Red-DiscordBot does not automatically read them for the Audio cog configuration by default. You can use them in custom cogs or scripts, or simply use them as a reference to configure the bot via command:
      ```
      [p]audioset lavalink host <LAVALINK_HOST>
      [p]audioset lavalink port <LAVALINK_PORT>
      [p]audioset lavalink password <LAVALINK_PASSWORD>
      ```
    - *Note: If you are using a custom startup cog, you can program it to read `os.environ['LAVALINK_HOST']` etc.*

## Troubleshooting

### Internal Lavalink Connection Failed
If you see errors like `Connecting to the Lavalink node failed after multiple attempts`, it might be due to Java binding to IPv6 while Red tries IPv4 (or vice versa).
- **Fix**: The Dockerfile now includes `ENV JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true"` to force IPv4. Rebuild the container to apply this.

### Memory Issues
Red-DiscordBot might try to allocate too much memory for Lavalink (e.g., `-Xmx15G`) if the container limits are not visible to Java.
- **Fix**: If the bot crashes or Lavalink fails to start, consider setting a memory limit in the Pterodactyl panel or passing `_JAVA_OPTIONS="-Xmx1G"` (or appropriate size) in the environment variables.
