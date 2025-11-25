# Implementation Plan - Update Docker Image

## Goal
Update the Pterodactyl Egg configuration to use the user's custom Docker image `ghcr.io/mathygamersyt/red-discordbot:latest` instead of the default one.

## Proposed Changes

### Configuration
#### [MODIFY] [egg-red-discord-bot.json](file:///o:/VS%20BOTS/egg-red-discord-bot.json)
- Update the `docker_images` section to include `ghcr.io/mathygamersyt/red-discordbot:latest`.
- Replace the existing image entry to ensure the new one is the default.

## Verification Plan

### Manual Verification
- Inspect the `egg-red-discord-bot.json` file to ensure the JSON structure is valid and the image URL is correct.
- The user will need to import the Egg into their panel to verify it pulls the correct image.
