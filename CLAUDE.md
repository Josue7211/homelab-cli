# Homelab CLI

16 bash CLIs for managing a self-hosted homelab: Portainer, Plex, ARR suite, AdGuard, Koel, Firecrawl, Overseerr, Jellyfin, qBittorrent, SABnzbd, Gluetun, Vault, OPNsense, CrowdSec, Pelican, and a unified `homelab` dashboard.

## Tech Stack

- Pure bash 4.0+ (no npm/pip)
- Dependencies: curl, python3 (inline JSON parsing), bw CLI (optional)
- Shared library: `lib/common.sh` (API helpers, secret retrieval, formatting)
- Config: `~/.config/homelab-cli/config` (sourced at runtime)

## Project Structure

```
bin/          # 16 CLI scripts (one per service)
lib/common.sh # Shared: api_get/post/put/delete, get_secret, format_table, colors
config.example # Template config (safe to commit)
install.sh    # Symlinks bin/* into ~/.local/bin/
```

## Commands

```bash
./install.sh                    # Install (symlink to ~/.local/bin/)
<cli> help                      # Full command reference for any CLI
```

## Key Conventions

- All secrets via Vaultwarden `bw` CLI at runtime -- never hardcoded
- Container ops go through Portainer API, never Docker CLI directly
- Destructive ops require `confirm_action` prompt
- Name-to-ID resolution via `resolve_*_id` helpers
- Inline python3 for JSON parsing (no jq dependency)
- Each CLI sources `lib/common.sh` at top

## Status

v2.0 shipped. 10,526 lines across 16 CLIs. ~130 commands. See `.planning/` for history.
