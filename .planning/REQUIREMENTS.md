# Requirements: Homelab CLI v2.0 Full Coverage

**Defined:** 2026-03-21
**Core Value:** Every homelab operation available in a web UI can be performed from the command line

**Safety convention:** All destructive operations (delete, prune, remove) prompt "Are you sure? (y/N)" before executing.

## v1 Requirements

### OpenCLI Integration

- [ ] **OCLI-01**: All 14 CLIs registered in `~/.opencli/external-clis.yaml` with name, binary, description, and tags
- [ ] **OCLI-02**: `opencli list` shows all homelab CLIs with `[installed]` tag
- [ ] **OCLI-03**: `opencli <cli> <command>` passthrough works for all registered CLIs

### Portainer — Stack Management

- [ ] **PT-01**: Create stack from compose file (`portainer create <inst> <name> -f <file> [--env K=V...]`)
- [ ] **PT-02**: Create stack from stdin (`echo "yaml..." | portainer create <inst> <name> --inline`)
- [ ] **PT-03**: Delete stack with confirmation prompt (`portainer delete <inst> <name>`)
- [ ] **PT-04**: Start stopped stack (`portainer start-stack <inst> <name>`)
- [ ] **PT-05**: Stop running stack (`portainer stop-stack <inst> <name>`)
- [ ] **PT-06**: Update stack environment variables (`portainer update-env <inst> <name> K=V...`)
- [ ] **PT-07**: Update stack compose file and redeploy (`portainer edit <inst> <name> -f <file>`)

### Portainer — Container Management

- [ ] **PT-08**: Stop container (`portainer stop-ct <inst> <name>`)
- [ ] **PT-09**: Start container (`portainer start-ct <inst> <name>`)
- [ ] **PT-10**: Inspect container details — ports, mounts, env, state (`portainer inspect <inst> <name>`)
- [ ] **PT-11**: Execute command in container (`portainer exec <inst> <name> <cmd...>`)
- [ ] **PT-12**: Show running processes in container (`portainer top <inst> <name>`)

### Portainer — Resources

- [ ] **PT-13**: List Docker volumes (`portainer volumes [inst]`)
- [ ] **PT-14**: Remove volume with confirmation (`portainer volume-rm <inst> <name>`)
- [ ] **PT-15**: List Docker networks with subnet info (`portainer networks [inst]`)
- [ ] **PT-16**: List Docker images with sizes (`portainer images [inst]`)
- [ ] **PT-17**: Pull Docker image (`portainer pull <inst> <image[:tag]>`)
- [ ] **PT-18**: Prune unused resources with confirmation (`portainer prune <inst> [--images] [--volumes] [--all]`)
- [ ] **PT-19**: List Docker endpoints (`portainer endpoints`)

### Portainer — DRY Refactor

- [ ] **PT-20**: Extract `resolve_container_id` shared helper (deduplicate from logs/restart)

### ARR Suite — Library Management

- [ ] **ARR-01**: Add series/movie/artist to library (`arr add <app> <id> [--quality <profile>] [--root <path>]`)
- [ ] **ARR-02**: Delete series/movie/artist from library with confirmation (`arr delete <app> <id>`)
- [ ] **ARR-03**: Trigger manual search/download for item (`arr download <app> <id>`)
- [ ] **ARR-04**: Trigger rename for item (`arr rename <app> <id>`)

### ARR Suite — Configuration

- [ ] **ARR-05**: List quality profiles (`arr profiles <app>`)
- [ ] **ARR-06**: List root folders (`arr rootfolders <app>`)
- [ ] **ARR-07**: List tags (`arr tags <app>`)
- [ ] **ARR-08**: Create tag (`arr tag-add <app> <label>`)
- [ ] **ARR-09**: List indexers (`arr indexers [app]`)

### ARR Suite — Maintenance

- [ ] **ARR-10**: Show blocklist (`arr blocklist <app>`)
- [ ] **ARR-11**: Clear blocklist with confirmation (`arr blocklist-clear <app>`)
- [ ] **ARR-12**: Trigger backup (`arr backup <app>`)
- [ ] **ARR-13**: View application logs (`arr logs <app> [count]`)
- [ ] **ARR-14**: Restart application (`arr restart <app>`)

### Proxmox/Homelab — VM Management

- [ ] **PVE-01**: Show VM configuration (`homelab config <vmid>`)
- [ ] **PVE-02**: Modify VM config (`homelab set <vmid> KEY=VAL...`)
- [ ] **PVE-03**: Resize VM disk (`homelab resize <vmid> <disk> <size>`)
- [ ] **PVE-04**: Clone VM (`homelab clone <vmid> [--name <name>]`)
- [ ] **PVE-05**: Create snapshot (`homelab snapshot-create <vmid> <name>`)
- [ ] **PVE-06**: Restore snapshot with confirmation (`homelab snapshot-restore <vmid> <name>`)
- [ ] **PVE-07**: Delete snapshot with confirmation (`homelab snapshot-delete <vmid> <name>`)

### Proxmox/Homelab — Cluster

- [ ] **PVE-08**: List cluster nodes (`homelab nodes`)
- [ ] **PVE-09**: List recent tasks (`homelab tasks [count]`)
- [ ] **PVE-10**: Backup VM (`homelab backup <vmid>`)
- [ ] **PVE-11**: Migrate VM to another node (`homelab migrate <vmid> <node>`)

### Plex — Expanded Management

- [ ] **PLEX-01**: List playlists (`plex playlists`)
- [ ] **PLEX-02**: List collections for a library (`plex collections [library_id]`)
- [ ] **PLEX-03**: Manage sharing — list shared users (`plex shared`)
- [ ] **PLEX-04**: Kill/stop a stream (`plex kill <session_id>`)
- [ ] **PLEX-05**: Optimize/clean bundles (`plex optimize`)
- [ ] **PLEX-06**: Empty trash for library (`plex empty-trash [library_id]`)
- [ ] **PLEX-07**: Show server preferences/settings (`plex settings`)
- [ ] **PLEX-08**: Show bandwidth/transcode info for active streams (`plex transcode`)

### Jellyfin — Expanded Management

- [ ] **JF-01**: List users (`jellyfin users`)
- [ ] **JF-02**: Create user (`jellyfin user-add <name> <password>`)
- [ ] **JF-03**: Delete user with confirmation (`jellyfin user-rm <name>`)
- [ ] **JF-04**: List scheduled tasks (`jellyfin tasks`)
- [ ] **JF-05**: Run scheduled task (`jellyfin run-task <id>`)
- [ ] **JF-06**: List plugins (`jellyfin plugins`)
- [ ] **JF-07**: Show system activity log (`jellyfin activity [count]`)
- [ ] **JF-08**: Show server info/config (`jellyfin info`)

### qBittorrent — Expanded Management

- [ ] **QBT-01**: Show torrent detail (`qbt info <hash>`)
- [ ] **QBT-02**: List files in torrent (`qbt files <hash>`)
- [ ] **QBT-03**: Set torrent priority (`qbt priority <hash> <max|min|up|down>`)
- [ ] **QBT-04**: Set download speed limit (`qbt limit-dl <speed_KB>`)
- [ ] **QBT-05**: Set upload speed limit (`qbt limit-ul <speed_KB>`)
- [ ] **QBT-06**: List categories (`qbt categories`)
- [ ] **QBT-07**: Set torrent category (`qbt set-category <hash> <category>`)
- [ ] **QBT-08**: Move torrent files to new location (`qbt move <hash> <path>`)
- [ ] **QBT-09**: Show torrent trackers (`qbt trackers <hash>`)
- [ ] **QBT-10**: Show torrent peers (`qbt peers <hash>`)

### AdGuard — Expanded Management

- [ ] **AG-01**: List DHCP leases (`adguard dhcp`)
- [ ] **AG-02**: Add static DHCP lease (`adguard dhcp-add <mac> <ip> <hostname>`)
- [ ] **AG-03**: List DNS rewrites (`adguard rewrites`)
- [ ] **AG-04**: Add DNS rewrite (`adguard rewrite-add <domain> <answer>`)
- [ ] **AG-05**: Remove DNS rewrite with confirmation (`adguard rewrite-rm <domain>`)
- [ ] **AG-06**: Remove custom rule (`adguard unblock <domain>` / `adguard unallow <domain>`)
- [ ] **AG-07**: List clients (`adguard clients`)
- [ ] **AG-08**: Show per-client stats (`adguard client <ip>`)

### Overseerr — Expanded Management

- [ ] **OVR-01**: Bulk approve pending requests (`overseerr approve-all`)
- [ ] **OVR-02**: List users and quotas (`overseerr users`)
- [ ] **OVR-03**: Show request detail (`overseerr request <id>`)
- [ ] **OVR-04**: List available services/servers (`overseerr services`)
- [ ] **OVR-05**: Show notification settings (`overseerr notifications`)

### OPNsense — Expanded Management

- [ ] **OPN-01**: Create firewall rule (`opnsense rule-add --src <ip> --dst <ip> --port <port> --action <pass|block>`)
- [ ] **OPN-02**: Delete firewall rule with confirmation (`opnsense rule-rm <uuid>`)
- [ ] **OPN-03**: Enable/disable firewall rule (`opnsense rule-toggle <uuid>`)
- [ ] **OPN-04**: Create firewall alias (`opnsense alias-add <name> <type> <content>`)
- [ ] **OPN-05**: Add DHCP static mapping (`opnsense dhcp-add <mac> <ip> <hostname>`)
- [ ] **OPN-06**: List WireGuard/OpenVPN tunnels (`opnsense vpn`)
- [ ] **OPN-07**: Apply pending firewall changes (`opnsense apply`)
- [ ] **OPN-08**: Show traffic graphs/stats (`opnsense traffic`)

### SABnzbd — Expanded Management

- [ ] **SAB-01**: Show NZB detail in queue (`sab info <nzo_id>`)
- [ ] **SAB-02**: Delete item from queue with confirmation (`sab delete <nzo_id>`)
- [ ] **SAB-03**: Pause single item (`sab pause-item <nzo_id>`)
- [ ] **SAB-04**: Resume single item (`sab resume-item <nzo_id>`)
- [ ] **SAB-05**: Set queue priority (`sab priority <nzo_id> <high|normal|low|force>`)
- [ ] **SAB-06**: List categories (`sab categories`)
- [ ] **SAB-07**: Set speed limit (`sab limit <speed_KB|0>`)
- [ ] **SAB-08**: Show server stats (`sab servers`)

### Gluetun — Expanded Management

- [ ] **GLU-01**: Show VPN provider info (`gluetun provider`)
- [ ] **GLU-02**: List available servers/regions (`gluetun servers`)
- [ ] **GLU-03**: Switch server/region (`gluetun switch <server>`)
- [ ] **GLU-04**: Show DNS config (`gluetun dns`)
- [ ] **GLU-05**: Show port forward status and history (`gluetun ports`)
- [ ] **GLU-06**: Check for DNS leaks (`gluetun leak-test`)

### Vault — Expanded Management

- [ ] **BW-01**: Create new vault item (`vault create <name> --user <user> --pass <pass> [--uri <url>]`)
- [ ] **BW-02**: Edit vault item field (`vault edit <name> --field <field> --value <val>`)
- [ ] **BW-03**: Delete vault item with confirmation (`vault delete <name>`)
- [ ] **BW-04**: List folders (`vault folders`)
- [ ] **BW-05**: Generate password (`vault generate [--length N]`)
- [ ] **BW-06**: Show TOTP code for item (`vault totp <name>`)

### Firecrawl — Expanded Management

- [ ] **FC-01**: Scrape with custom options (`firecrawl scrape <url> --wait <ms> --headers <json>`)
- [ ] **FC-02**: Batch scrape multiple URLs (`firecrawl batch <url1> <url2>...`)
- [ ] **FC-03**: Crawl with depth/filter options (`firecrawl crawl <url> --depth <n> --include <pattern>`)
- [ ] **FC-04**: Cancel running crawl job (`firecrawl cancel <job_id>`)
- [ ] **FC-05**: List recent jobs (`firecrawl jobs`)

### Koel — API Integration

- [ ] **KOEL-01**: Search music library (`koel search <query>`)
- [ ] **KOEL-02**: List playlists (`koel playlists`)
- [ ] **KOEL-03**: Show recently played (`koel recent`)
- [ ] **KOEL-04**: Show library stats (`koel stats`)
- [ ] **KOEL-05**: List albums/artists (`koel albums` / `koel artists`)

### Common Library

- [x] **LIB-01**: Add `confirm_action` helper — prompts "Are you sure? (y/N)" for destructive operations
- [x] **LIB-02**: Add `api_patch` helper for PATCH requests

### Help Text Updates

- [ ] **HELP-01**: Update all 14 CLI help texts to include new commands

## v2 Requirements

Deferred to future milestone. Tracked but not in current roadmap.

### Advanced Automation
- **AUTO-01**: Batch operations across multiple services (e.g., "pause all downloads")
- **AUTO-02**: Health check dashboard across all services in one command
- **AUTO-03**: Webhook/notification integration for long-running operations

### Koel Full API Migration
- **KOEL-10**: Replace all SSH/docker-exec operations with Koel REST API
- **KOEL-11**: Playback control via API

## Out of Scope

| Feature | Reason |
|---------|--------|
| GUI/TUI interfaces | CLIs are terminal-first, not ncurses |
| Container management via Docker API directly | Must go through Portainer |
| Automated scheduling | Use cron externally |
| Multi-user support | Single operator with Vaultwarden |
| Service installation/setup | CLIs manage, don't install |
| Proxmox VM creation from scratch | Complex wizard, use web UI |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| LIB-01 | Phase 1: Foundation | Complete |
| LIB-02 | Phase 1: Foundation | Complete |
| OCLI-01 | Phase 1: Foundation | Pending |
| OCLI-02 | Phase 1: Foundation | Pending |
| OCLI-03 | Phase 1: Foundation | Pending |
| PT-01 | Phase 2: Portainer | Pending |
| PT-02 | Phase 2: Portainer | Pending |
| PT-03 | Phase 2: Portainer | Pending |
| PT-04 | Phase 2: Portainer | Pending |
| PT-05 | Phase 2: Portainer | Pending |
| PT-06 | Phase 2: Portainer | Pending |
| PT-07 | Phase 2: Portainer | Pending |
| PT-08 | Phase 2: Portainer | Pending |
| PT-09 | Phase 2: Portainer | Pending |
| PT-10 | Phase 2: Portainer | Pending |
| PT-11 | Phase 2: Portainer | Pending |
| PT-12 | Phase 2: Portainer | Pending |
| PT-13 | Phase 2: Portainer | Pending |
| PT-14 | Phase 2: Portainer | Pending |
| PT-15 | Phase 2: Portainer | Pending |
| PT-16 | Phase 2: Portainer | Pending |
| PT-17 | Phase 2: Portainer | Pending |
| PT-18 | Phase 2: Portainer | Pending |
| PT-19 | Phase 2: Portainer | Pending |
| PT-20 | Phase 2: Portainer | Pending |
| ARR-01 | Phase 3: ARR Suite | Pending |
| ARR-02 | Phase 3: ARR Suite | Pending |
| ARR-03 | Phase 3: ARR Suite | Pending |
| ARR-04 | Phase 3: ARR Suite | Pending |
| ARR-05 | Phase 3: ARR Suite | Pending |
| ARR-06 | Phase 3: ARR Suite | Pending |
| ARR-07 | Phase 3: ARR Suite | Pending |
| ARR-08 | Phase 3: ARR Suite | Pending |
| ARR-09 | Phase 3: ARR Suite | Pending |
| ARR-10 | Phase 3: ARR Suite | Pending |
| ARR-11 | Phase 3: ARR Suite | Pending |
| ARR-12 | Phase 3: ARR Suite | Pending |
| ARR-13 | Phase 3: ARR Suite | Pending |
| ARR-14 | Phase 3: ARR Suite | Pending |
| PVE-01 | Phase 4: Proxmox | Pending |
| PVE-02 | Phase 4: Proxmox | Pending |
| PVE-03 | Phase 4: Proxmox | Pending |
| PVE-04 | Phase 4: Proxmox | Pending |
| PVE-05 | Phase 4: Proxmox | Pending |
| PVE-06 | Phase 4: Proxmox | Pending |
| PVE-07 | Phase 4: Proxmox | Pending |
| PVE-08 | Phase 4: Proxmox | Pending |
| PVE-09 | Phase 4: Proxmox | Pending |
| PVE-10 | Phase 4: Proxmox | Pending |
| PVE-11 | Phase 4: Proxmox | Pending |
| PLEX-01 | Phase 5: Plex | Pending |
| PLEX-02 | Phase 5: Plex | Pending |
| PLEX-03 | Phase 5: Plex | Pending |
| PLEX-04 | Phase 5: Plex | Pending |
| PLEX-05 | Phase 5: Plex | Pending |
| PLEX-06 | Phase 5: Plex | Pending |
| PLEX-07 | Phase 5: Plex | Pending |
| PLEX-08 | Phase 5: Plex | Pending |
| JF-01 | Phase 6: Jellyfin | Pending |
| JF-02 | Phase 6: Jellyfin | Pending |
| JF-03 | Phase 6: Jellyfin | Pending |
| JF-04 | Phase 6: Jellyfin | Pending |
| JF-05 | Phase 6: Jellyfin | Pending |
| JF-06 | Phase 6: Jellyfin | Pending |
| JF-07 | Phase 6: Jellyfin | Pending |
| JF-08 | Phase 6: Jellyfin | Pending |
| QBT-01 | Phase 7: qBittorrent | Pending |
| QBT-02 | Phase 7: qBittorrent | Pending |
| QBT-03 | Phase 7: qBittorrent | Pending |
| QBT-04 | Phase 7: qBittorrent | Pending |
| QBT-05 | Phase 7: qBittorrent | Pending |
| QBT-06 | Phase 7: qBittorrent | Pending |
| QBT-07 | Phase 7: qBittorrent | Pending |
| QBT-08 | Phase 7: qBittorrent | Pending |
| QBT-09 | Phase 7: qBittorrent | Pending |
| QBT-10 | Phase 7: qBittorrent | Pending |
| AG-01 | Phase 8: AdGuard | Pending |
| AG-02 | Phase 8: AdGuard | Pending |
| AG-03 | Phase 8: AdGuard | Pending |
| AG-04 | Phase 8: AdGuard | Pending |
| AG-05 | Phase 8: AdGuard | Pending |
| AG-06 | Phase 8: AdGuard | Pending |
| AG-07 | Phase 8: AdGuard | Pending |
| AG-08 | Phase 8: AdGuard | Pending |
| OPN-01 | Phase 9: OPNsense | Pending |
| OPN-02 | Phase 9: OPNsense | Pending |
| OPN-03 | Phase 9: OPNsense | Pending |
| OPN-04 | Phase 9: OPNsense | Pending |
| OPN-05 | Phase 9: OPNsense | Pending |
| OPN-06 | Phase 9: OPNsense | Pending |
| OPN-07 | Phase 9: OPNsense | Pending |
| OPN-08 | Phase 9: OPNsense | Pending |
| SAB-01 | Phase 10: SABnzbd | Pending |
| SAB-02 | Phase 10: SABnzbd | Pending |
| SAB-03 | Phase 10: SABnzbd | Pending |
| SAB-04 | Phase 10: SABnzbd | Pending |
| SAB-05 | Phase 10: SABnzbd | Pending |
| SAB-06 | Phase 10: SABnzbd | Pending |
| SAB-07 | Phase 10: SABnzbd | Pending |
| SAB-08 | Phase 10: SABnzbd | Pending |
| GLU-01 | Phase 11: Gluetun | Pending |
| GLU-02 | Phase 11: Gluetun | Pending |
| GLU-03 | Phase 11: Gluetun | Pending |
| GLU-04 | Phase 11: Gluetun | Pending |
| GLU-05 | Phase 11: Gluetun | Pending |
| GLU-06 | Phase 11: Gluetun | Pending |
| OVR-01 | Phase 12: Overseerr | Pending |
| OVR-02 | Phase 12: Overseerr | Pending |
| OVR-03 | Phase 12: Overseerr | Pending |
| OVR-04 | Phase 12: Overseerr | Pending |
| OVR-05 | Phase 12: Overseerr | Pending |
| BW-01 | Phase 13: Vault | Pending |
| BW-02 | Phase 13: Vault | Pending |
| BW-03 | Phase 13: Vault | Pending |
| BW-04 | Phase 13: Vault | Pending |
| BW-05 | Phase 13: Vault | Pending |
| BW-06 | Phase 13: Vault | Pending |
| FC-01 | Phase 14: Firecrawl | Pending |
| FC-02 | Phase 14: Firecrawl | Pending |
| FC-03 | Phase 14: Firecrawl | Pending |
| FC-04 | Phase 14: Firecrawl | Pending |
| FC-05 | Phase 14: Firecrawl | Pending |
| KOEL-01 | Phase 15: Koel | Pending |
| KOEL-02 | Phase 15: Koel | Pending |
| KOEL-03 | Phase 15: Koel | Pending |
| KOEL-04 | Phase 15: Koel | Pending |
| KOEL-05 | Phase 15: Koel | Pending |
| HELP-01 | Phase 16: Help Text | Pending |

**Coverage:**
- v1 requirements: 128 total
- Mapped to phases: 128
- Unmapped: 0

---
*Requirements defined: 2026-03-21*
*Last updated: 2026-03-21 after roadmap creation*
