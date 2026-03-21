# Configuration Reference

All CLIs read from `~/.config/homelab-cli/config`. This file is a bash script that gets sourced, so you can use variable expansion (e.g., `http://${PLEX_VM_IP}:8989`).

Override the config path with the `HOMELAB_CONFIG` environment variable.

## Network

```bash
PROXMOX_HOST="https://192.168.1.100:8006"   # Proxmox VE URL
PLEX_VM_IP="192.168.1.101"                   # Media/Plex VM IP
SERVICES_VM_IP="192.168.1.102"               # Services VM IP
```

## Proxmox (`homelab`)

```bash
PVE_TOKEN_ID="root@pam!my-token"          # API token ID
PVE_TOKEN_SOURCE="bw"                      # bw | env | file
PVE_TOKEN_BW_ENTRY="Proxmox API Token"     # Vaultwarden entry name
PVE_NODE="pve"                              # Proxmox node name
```

## Portainer (`portainer`, `homelab`)

```bash
PORTAINER_PLEX="http://192.168.1.101:9000"
PORTAINER_SERVICES="https://192.168.1.102:9443"
PORTAINER_TOKEN_SOURCE="bw"
PORTAINER_PLEX_BW_ENTRY="Portainer API - Plex"
PORTAINER_SERVICES_BW_ENTRY="Portainer API - Services"
PORTAINER_PLEX_ENDPOINT_ID=3
PORTAINER_SERVICES_ENDPOINT_ID=3
```

## *ARR Suite (`arr`)

All five *ARR apps follow the same pattern. Replace `SONARR` with `RADARR`, `LIDARR`, `PROWLARR`, or `BAZARR`.

```bash
SONARR_URL="http://${PLEX_VM_IP}:8989"
SONARR_API_KEY_SOURCE="config"            # config | bw | env
```

### API Key Sources

**`config`** — Reads the API key from the app's config.xml via SSH:

```bash
SONARR_API_KEY_SOURCE="config"
SONARR_API_KEY_SSH_HOST="my-media-vm"     # SSH alias or hostname
SONARR_API_KEY_CONFIG_PATH="/path/to/sonarr/config.xml"
```

**`bw`** — Retrieves from Vaultwarden/Bitwarden:

```bash
SONARR_API_KEY_SOURCE="bw"
SONARR_API_KEY_BW_ENTRY="Sonarr API Key"  # Vault entry name
```

**`env`** — Reads from environment variable `SONARR_API_KEY`:

```bash
SONARR_API_KEY_SOURCE="env"
```

### Default Ports

| App | Default Port | Config Variable |
|-----|-------------|----------------|
| Sonarr | 8989 | `SONARR_URL` |
| Radarr | 7878 | `RADARR_URL` |
| Lidarr | 8686 | `LIDARR_URL` |
| Prowlarr | 9696 | `PROWLARR_URL` |
| Bazarr | 6767 | `BAZARR_URL` |

Note: Bazarr uses `config.yaml` instead of `config.xml`.

## Download Clients

### qBittorrent (`qbt`)

```bash
QBIT_URL="http://${PLEX_VM_IP}:8082"
QBIT_USER="admin"
QBIT_PASS_SOURCE="bw"                    # bw | env
QBIT_PASS_BW_ENTRY="qBittorrent"
```

### SABnzbd (`sab`)

```bash
SAB_URL="http://${PLEX_VM_IP}:8090"
SAB_API_KEY_SOURCE="bw"
SAB_API_KEY_BW_ENTRY="SABnzbd API Key"
```

## Media Servers

### Plex (`plex`)

```bash
PLEX_URL="http://${PLEX_VM_IP}:32400"
PLEX_TOKEN_SOURCE="bw"
PLEX_TOKEN_BW_ENTRY="Plex Token"
```

To get your Plex token: open Plex Web, inspect any API request, find `X-Plex-Token` in the URL.

### Jellyfin (`jellyfin`)

```bash
JELLYFIN_URL="http://${PLEX_VM_IP}:8096"
JELLYFIN_API_KEY_SOURCE="bw"
JELLYFIN_API_KEY_BW_ENTRY="Jellyfin API Key"
```

Generate an API key in Jellyfin: Dashboard > API Keys > New.

### Tautulli (used by `plex`)

```bash
TAUTULLI_URL="http://${PLEX_VM_IP}:8181"
TAUTULLI_API_KEY_SOURCE="bw"
TAUTULLI_API_KEY_BW_ENTRY="Tautulli API Key"
```

Find the API key in Tautulli: Settings > Web Interface > API Key.

## Other Services

### Overseerr (`overseerr`)

```bash
OVERSEERR_URL="http://${PLEX_VM_IP}:5055"
OVERSEERR_API_KEY_SOURCE="bw"
OVERSEERR_API_KEY_BW_ENTRY="Overseerr API Key"
```

Find the API key in Overseerr: Settings > General > API Key.

### AdGuard Home (`adguard`)

```bash
ADGUARD_URL="http://192.168.1.10"
ADGUARD_BW_ENTRY="AdGuard Home"
```

Uses HTTP basic auth. Store the AdGuard username and password in a Vaultwarden entry.

### Gluetun (`gluetun`)

```bash
GLUETUN_URL="http://${PLEX_VM_IP}:8000"
```

No authentication required. Make sure the Gluetun control server port (default 8000) is mapped in your docker-compose.

### Koel (`koel`)

```bash
KOEL_URL="http://${PLEX_VM_IP}:8000"
KOEL_SSH_HOST="my-media-vm"              # Required — SSH alias for docker exec
KOEL_CONTAINER="koel"
KOEL_DB_CONTAINER="koel-db"
KOEL_DB_USER="koel"
KOEL_DB_NAME="koel"
```

### Firecrawl (`firecrawl`)

```bash
FIRECRAWL_URL="http://${SERVICES_VM_IP}:3002"
```

No authentication required for self-hosted Firecrawl.

### Vaultwarden (`vault`)

No config needed — wraps the `bw` CLI directly. Make sure `bw` is installed and configured:

```bash
bw login
bw unlock
export BW_SESSION="..."
```

## Environment Variable Override

Any config variable can be overridden via environment variable:

```bash
SONARR_URL="http://different-host:8989" arr queue
```

The config file path itself can be changed:

```bash
HOMELAB_CONFIG="/path/to/alt/config" arr status
```
