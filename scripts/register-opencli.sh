#!/usr/bin/env bash
# register-opencli.sh - Register all 14 homelab CLIs with OpenCLI
# Run once after initial setup, or again to update descriptions.
# Idempotent: safe to re-run (updates existing entries).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

require_cmd opencli

header "REGISTERING HOMELAB CLIs WITH OPENCLI"

register() {
    local name="$1" desc="$2"
    opencli register "$name" --binary "$name" --desc "$desc"
}

register portainer   "Portainer — Docker stack and container management across instances"
register arr         "ARR Suite — Sonarr, Radarr, Lidarr media automation management"
register homelab     "Homelab — Proxmox VM management, snapshots, and cluster operations"
register plex        "Plex — Media server, streams, libraries, and server management"
register jellyfin    "Jellyfin — Media server, users, tasks, plugins, and activity"
register adguard     "AdGuard Home — DNS filtering, DHCP, rewrites, and client stats"
register qbt         "qBittorrent — Torrent management, speed limits, and categories"
register sab         "SABnzbd — Usenet download queue, priorities, and server stats"
register overseerr   "Overseerr — Media request management, approvals, and users"
register gluetun     "Gluetun — VPN status, server switching, and leak testing"
register koel        "Koel — Music library, playlists, search, and playback"
register firecrawl   "Firecrawl — Web scraping, crawling, and job management"
register vault       "Vault — Vaultwarden password management, TOTP, and folders"
register opnsense    "OPNsense — Firewall rules, aliases, DHCP, VPN, and traffic"

echo ""
ok "All 14 homelab CLIs registered with OpenCLI."
info "Run 'opencli list' to verify."
