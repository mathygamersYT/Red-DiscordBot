<h1 align="center">
  <br>
  <a href="https://github.com/Cog-Creators/Red-DiscordBot/tree/V3/develop"><img src="https://imgur.com/pY1WUFX.png" alt="Red - Discord Bot"></a>
  <br>
  Red Discord Bot
  <br>
</h1>

<h4 align="center">Music, Moderation, Trivia, Stream Alerts and Fully Modular.</h4>

<p align="center">
  <a href="https://discord.gg/red">
    <img src="https://discordapp.com/api/guilds/133049272517001216/widget.png?style=shield" alt="Discord Server">
  </a>
  <a href="https://pypi.org/project/Red-DiscordBot/">
     <img alt="PyPI" src="https://img.shields.io/pypi/v/Red-Discordbot">
  </a>
  <a href="https://www.python.org/downloads/">
    <img alt="PyPI - Python Version" src="https://img.shields.io/pypi/pyversions/Red-Discordbot">
  </a>
  <a href="https://github.com/Rapptz/discord.py/">
     <img src="https://img.shields.io/badge/discord-py-blue.svg" alt="discord.py">
  </a>
  <a href="https://www.patreon.com/Red_Devs">
    <img src="https://img.shields.io/badge/Support-Red!-red.svg" alt="Support Red on Patreon!">
  </a>
</p>
<p align="center">
  <a href="https://github.com/Cog-Creators/Red-DiscordBot/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/Cog-Creators/Red-Discordbot/tests.yml?label=tests" alt="GitHub Actions">
  </a>
  <a href="http://docs.discord.red/en/stable/?badge=stable">
    <img src="https://readthedocs.org/projects/red-discordbot/badge/?version=stable" alt="Red on readthedocs.org">
  </a>
  <a href="https://github.com/psf/black">
    <img src="https://img.shields.io/badge/code%20style-black-000000.svg" alt="Code Style: Black">
  </a>
  <a href="http://makeapullrequest.com">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg">
  </a>
  <a href="https://crowdin.com/project/red-discordbot">
    <img src="https://d322cqt584bo4o.cloudfront.net/red-discordbot/localized.svg" alt="Localized with Crowdin">
  </a>
</p>

<p align="center">
  <a href="#overview">Overview</a>
  •
  <a href="#installation">Installation</a>
  •
  <a href="http://docs.discord.red/en/stable/index.html">Documentation</a>
  •
  <a href="#plugins">Plugins</a>
  •
  <a href="#join-the-community">Community</a>
  •
  <a href="#license">License</a>
</p>

# Overview

Red is a fully modular bot – meaning all features and commands can be enabled/disabled to your
liking, making it completely customizable. This is a *self-hosted bot* – meaning you will need
to host and maintain your own instance. You can turn Red into an admin bot, music bot, trivia bot,
new best friend or all of these together!  

[Installation](#installation) is easy, and you do **NOT** need to know anything about coding! Aside
from installing and updating, every part of the bot can be controlled from within Discord.

**The default set of modules includes and is not limited to:**

- Moderation features (kick/ban/softban/hackban, mod-log, filter, chat cleanup)
- Trivia (lists are included and can be easily added)
- Music features (YouTube, SoundCloud, local files, playlists, queues)
- Stream alerts (Twitch, Youtube, Picarto)
- Bank (slot machine, user credits)
- Custom commands
- Imgur/gif search
- Admin automation (self-role assignment, cross-server announcements, mod-mail reports)
- Customisable command permissions

**Additionally, other [plugins](#plugins) (cogs) can be easily found and added from our growing
community of cog repositories.**

# Installation

**The following platforms are officially supported:** 

- [Windows](https://docs.discord.red/en/stable/install_guides/windows.html)
- [MacOS](https://docs.discord.red/en/stable/install_guides/mac.html)
- [Most major linux distributions](https://docs.discord.red/en/stable/install_guides/index.html)

[Official Discord Server](https://discord.gg/red) and ask in the **#support** channel for help.

## 🚀 Recommended Installation Guide: Red-Bot with Managed Lavalink (Pterodactyl/Pelican)

This guide ensures Red-Bot and the Lavalink audio server communicate correctly within the same Docker container, resolving common port and host (`localhost` vs external IP) conflicts.

### 1. Server Preparation (Pterodactyl/Pelican Panel)

Navigate to the server creation section and complete the **"Information"** tab:

| Field | Recommended Value | Notes |
| :--- | :--- | :--- |
| **Name** | `MyRedBot` | Your preferred server name. |
| **Node** | `BOTS` | (Based on your host configuration). |
| **Primary Allocation** | `0.0.0.0:2333` | **Essential:** Map the server to port `2333`, which is the standard Lavalink port. |

**Resource Recommendations:**
- **Basic:** 150MB RAM, 1GB Disk Space. (Configure these limits within the Pelican Panel settings).
- **With Audio (Lavalink):** 1GB RAM, 1GB Disk Space. (Configure these limits within the Pelican Panel settings).

### 2. Environment Configuration (Crucial Step)

Navigate to the **"Environment Configuration"** tab. By setting these variables, you instruct Red-Bot to launch and utilize its own local Lavalink instance.

| Variable | Value | Explanation |
| :--- | :--- | :--- |
| **Bot Token** (`RED_TOKEN`) | `YOUR_DISCORD_BOT_TOKEN` | Your Discord bot's secret token (**mandatory**). |
| **Instance Name** (`INSTANCE_NAME`) | `red` | Internal name for the Red-Bot instance. |
| **Owner ID** (`OWNER_ID`) | `YOUR_DISCORD_USER_ID` | Your Discord user ID for superuser permissions (**mandatory**). |
| **Prefix** (`PREFIX`) | `!` | The command prefix you wish to use. |
| **Lavalink Host** (`LAVALINK_HOST`) | **Leave Blank** | **Key:** Leaving this empty tells Red-Bot to use its own local instance (`localhost`), ignoring problematic external IPs. |
| **Lavalink Port** (`LAVALINK_PORT`) | `2333` | **Key:** Forces Red-Bot to look for the service on the correct port. |
| **Lavalink Password** (`LAVALINK_PASSWORD`) | `youshallnotpass` | The standard Lavalink default password. |

### 3. Port Conflict Troubleshooting (Verification Step)

After installation, check the server console. If you see repeated `Failed connect attempt` errors, it means Lavalink may be attempting to bind to an incorrect port. 
Upon successful connection, the console should show:

> `Lavalink WS connecting to ws://localhost:2333...`
> `Lavalink WS connected to ws://localhost:2333`

# Plugins

Red is fully modular, allowing you to load and unload plugins of your choice, and install 3rd party
plugins directly from Discord! A few examples are:

- Cleverbot integration (talk to Red and she talks back)
- Ban sync
- Welcome messages
- Casino
- Reaction roles
- Slow Mode
- AniList
- And much, much more!

Feel free to take a [peek](https://index.discord.red) at a list of
available 3rd party cogs!

# Join the community!

**Red** is in continuous development, and it’s supported by an active community which produces new
content (cogs/plugins) for everyone to enjoy. New features are constantly added. If you can’t
[find](https://index.discord.red) the cog you’re looking for,
consult our [guide](https://docs.discord.red/en/stable/guide_cog_creation.html) on
building your own cogs!

Join us on our [Official Discord Server](https://discord.gg/red)!

# License

Released under the [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.en.html) license.

Red is named after the main character of "Transistor", a video game by
[Super Giant Games](https://www.supergiantgames.com/games/transistor/).

Artwork created by [Sinlaire](https://sinlaire.deviantart.com/) on Deviant Art for the Red Discord
Bot Project.

This project vendors [discord.ext.menus](https://github.com/Rapptz/discord-ext-menus) package made by Danny Y. (Rapptz) which is distributed under MIT License.
A copy of this license can be found in the [discord-ext-menus.LICENSE](redbot/vendored/discord-ext-menus.LICENSE) file in the [redbot/vendored](redbot/vendored) folder of this repository.
