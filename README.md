# homelab-cli

16 bash CLIs for managing a self-hosted homelab from any machine on your network. Config-driven, no hardcoded secrets.

## CLIs

| CLI | Service | What it does |
|-----|---------|-------------|
| `arr` | Sonarr, Radarr, Lidarr, Prowlarr, Bazarr | Queue, search, library, calendar, health checks |
| `homelab` | Proxmox VE + Portainer | VM management, service health dashboard |
| `portainer` | Portainer | Docker stacks, containers, logs, redeploy |
| `plex` | Plex + Tautulli | Streams, history, libraries, scan, search |
| `adguard` | AdGuard Home | DNS stats, filters, query log, block/allow |
| `koel` | Koel | Music server deploy, artisan, scan, logs |
| `firecrawl` | Firecrawl | Web scraping, crawling, search, extraction |
| `overseerr` | Overseerr | Media requests, approve/decline, search |
| `jellyfin` | Jellyfin | Streams, libraries, devices, scan |
| `qbt` | qBittorrent | Torrents: list, add, pause, resume, delete |
| `sab` | SABnzbd | Usenet queue, history, pause/resume |
| `gluetun` | Gluetun | VPN status, public IP, start/stop |
| `vault` | Vaultwarden | Secret lookup, search, sync |
| `crowdsec` | CrowdSec | Decisions, alerts, ban/unban IPs, bouncers, scenarios, metrics |
| `opnsense` | OPNsense | Firewall rules, interfaces, DHCP, DNS, VPN, traffic, firmware |
| `pelican` | Pelican Panel | Game servers, nodes, power control, backups, files, allocations |

## Quick Start

```bash
# Clone
git clone https://github.com/Josue7211/homelab-cli.git
cd homelab-cli

# Create your config
mkdir -p ~/.config/homelab-cli
cp config.example ~/.config/homelab-cli/config
$EDITOR ~/.config/homelab-cli/config

# Install (symlinks to ~/.local/bin/)
./install.sh
```

## Configuration

All CLIs read from `~/.config/homelab-cli/config`. Copy `config.example` and fill in your values:

```bash
# IPs/hostnames for your VMs
PROXMOX_HOST="https://192.168.1.100:8006"
PLEX_VM_IP="192.168.1.101"
SERVICES_VM_IP="192.168.1.102"

# *ARR suite
SONARR_URL="http://${PLEX_VM_IP}:8989"
RADARR_URL="http://${PLEX_VM_IP}:7878"
# ... etc
```

See [docs/configuration.md](docs/configuration.md) for the full reference.

## Secret Management

API keys and passwords are never stored in the repo or config file. Three retrieval methods are supported:

| Method | Config value | How it works |
|--------|-------------|-------------|
| **Bitwarden/Vaultwarden** | `bw` | Runs `bw get password "Entry Name"` at runtime |
| **Environment variable** | `env` | Reads from a named env var |
| **App config file** | `config` | SSHs into the host and reads the app's config.xml/yaml |

Example for Sonarr using the `config` method (reads API key directly from Sonarr's config.xml via SSH):

```bash
SONARR_API_KEY_SOURCE="config"
SONARR_API_KEY_SSH_HOST="my-media-vm"
SONARR_API_KEY_CONFIG_PATH="/path/to/sonarr/config.xml"
```

## Requirements

- `bash` 4.0+
- `curl`
- `python3` (for JSON parsing — no pip packages needed)
- `bw` CLI (optional — only if using Bitwarden/Vaultwarden for secrets)

## Usage Examples

```bash
# Dashboard — check everything at a glance
homelab status
arr status
arr health

# Manage download queue
arr queue                        # show all queues
arr queue sonarr                 # sonarr only
arr queue-clear s --completed    # clear stuck items

# Search and browse
arr search s "breaking bad"      # search sonarr
arr search r "inception"         # search radarr
arr library sonarr               # list all series
arr calendar                     # upcoming episodes

# Plex
plex streams                     # who's watching
plex recent                      # recently added
plex history                     # playback history

# DNS ad-blocking
adguard status                   # query stats
adguard blocked                  # blocked queries
adguard allow api.example.com    # allowlist a domain
adguard filters                  # list filter lists

# Docker management
portainer stacks plex            # list stacks
portainer logs plex koel 50      # container logs
portainer redeploy plex music    # pull + restart

# Torrents / Usenet
qbt list downloading             # active downloads
qbt status                       # speeds + counts
sab queue                        # usenet queue

# VPN
gluetun status                   # vpn state + public ip
gluetun ip                       # just the ip
```

Run any CLI with `help` for the full command reference:

```bash
arr help
plex help
adguard help
```

## Installing on Multiple Machines

These CLIs are thin HTTP clients — they work from any machine that can reach your services. To install on another machine:

```bash
git clone https://github.com/Josue7211/homelab-cli.git
cd homelab-cli
cp config.example ~/.config/homelab-cli/config
# Edit config with that machine's network details
./install.sh
```

## Project Structure

```
homelab-cli/
├── bin/            # All CLI scripts (one per service)
├── lib/
│   └── common.sh   # Shared config, colors, secret retrieval, API helpers
├── config.example  # Template config (safe to share)
├── install.sh      # Symlinks bin/* into ~/.local/bin/
└── LICENSE         # MIT
```

## License

MIT
