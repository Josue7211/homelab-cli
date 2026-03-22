# Roadmap: Homelab CLI v2.0 Full Coverage

## Overview

Expand all 14 homelab CLIs from ~45% to full API coverage, add shared library helpers, register everything with OpenCLI for AI agent discovery, and update all help texts. Phases are organized by CLI/service, starting with foundation (common library + OpenCLI registration), then Portainer (highest priority), then remaining CLIs in dependency and complexity order.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

- [ ] **Phase 1: Foundation** - Common library helpers and OpenCLI registration for all 14 CLIs
- [ ] **Phase 2: Portainer** - Full stack, container, and resource management via Portainer API
- [ ] **Phase 3: ARR Suite** - Library management, configuration, and maintenance for Sonarr/Radarr/Lidarr
- [ ] **Phase 4: Proxmox** - VM management, snapshots, and cluster operations
- [ ] **Phase 5: Plex** - Playlists, collections, sharing, stream control, and server management
- [ ] **Phase 6: Jellyfin** - User management, tasks, plugins, and server info
- [ ] **Phase 7: qBittorrent** - Torrent details, speed limits, categories, and tracker info
- [ ] **Phase 8: AdGuard** - DHCP leases, DNS rewrites, client management, and rule removal
- [ ] **Phase 9: OPNsense** - Firewall rule CRUD, aliases, DHCP mappings, VPN, and traffic stats
- [ ] **Phase 10: SABnzbd** - Queue item management, priorities, speed limits, and server stats
- [ ] **Phase 11: Gluetun** - VPN provider info, server switching, DNS config, and leak testing
- [ ] **Phase 12: Overseerr** - Bulk approval, user/quota listing, request details, and service info
- [ ] **Phase 13: Vault** - Item CRUD, folder listing, password generation, and TOTP codes
- [ ] **Phase 14: Firecrawl** - Custom scrape options, batch scrape, crawl options, and job management
- [ ] **Phase 15: Koel** - Music search, playlists, recently played, stats, and browsing
- [ ] **Phase 16: Help Text** - Update all 14 CLI help texts to include new commands

## Phase Details

### Phase 1: Foundation
**Goal**: Shared library helpers exist and all 14 CLIs are discoverable by AI agents via OpenCLI
**Depends on**: Nothing (first phase)
**Requirements**: LIB-01, LIB-02, OCLI-01, OCLI-02, OCLI-03
**Success Criteria** (what must be TRUE):
  1. Running any destructive command in any CLI triggers a "Are you sure? (y/N)" confirmation prompt (confirm_action helper works)
  2. Any CLI can make PATCH API requests using the shared api_patch helper
  3. `opencli list` shows all 14 homelab CLIs with `[installed]` tag
  4. `opencli portainer stacks` (or any CLI passthrough) executes the correct underlying CLI command
**Plans**: 2 plans

Plans:
- [x] 01-01-PLAN.md — Common library helpers (confirm_action, api_patch)
- [ ] 01-02-PLAN.md — OpenCLI registration for all 14 CLIs

### Phase 2: Portainer
**Goal**: Users can fully manage Docker stacks, containers, and resources across both Portainer instances from the command line
**Depends on**: Phase 1
**Requirements**: PT-01, PT-02, PT-03, PT-04, PT-05, PT-06, PT-07, PT-08, PT-09, PT-10, PT-11, PT-12, PT-13, PT-14, PT-15, PT-16, PT-17, PT-18, PT-19, PT-20
**Success Criteria** (what must be TRUE):
  1. User can create a new stack from a compose file, deploy it, and see it in `portainer stacks`
  2. User can stop, start, delete, and update stacks (compose and env vars) without touching the Portainer web UI
  3. User can stop, start, inspect, exec into, and view processes of any container across both instances
  4. User can list volumes, networks, images, and endpoints, and can pull images and prune unused resources
  5. Container ID resolution is deduplicated into a single shared helper (no code duplication between logs/restart/new commands)
**Plans**: 3 plans

- [x] 02-01-PLAN.md — DRY refactor (resolve_container_id) + stack CRUD (create, delete, start, stop)
- [x] 02-02-PLAN.md — Stack updates (update-env, edit) + container management (stop-ct, start-ct, inspect, exec, top)
- [x] 02-03-PLAN.md — Resource commands (volumes, volume-rm, networks, images, pull, prune, endpoints)

### Phase 3: ARR Suite
**Goal**: Users can fully manage media libraries, configuration, and maintenance for all ARR apps from the command line
**Depends on**: Phase 1
**Requirements**: ARR-01, ARR-02, ARR-03, ARR-04, ARR-05, ARR-06, ARR-07, ARR-08, ARR-09, ARR-10, ARR-11, ARR-12, ARR-13, ARR-14
**Success Criteria** (what must be TRUE):
  1. User can add, delete, search/download, and rename items in any ARR app library
  2. User can list quality profiles, root folders, tags, and indexers for any ARR app
  3. User can view and clear blocklists, trigger backups, view logs, and restart any ARR app
**Plans**: 3 plans

Plans:
- [x] 03-01-PLAN.md — Library management commands (add, delete, download, rename)
- [x] 03-02-PLAN.md — Configuration listing commands (profiles, rootfolders, tags, tag-add, indexers)
- [ ] 03-03-PLAN.md — Maintenance commands (blocklist, blocklist-clear, backup, logs, restart)

### Phase 4: Proxmox
**Goal**: Users can manage VM configurations, snapshots, and cluster operations from the command line
**Depends on**: Phase 1
**Requirements**: PVE-01, PVE-02, PVE-03, PVE-04, PVE-05, PVE-06, PVE-07, PVE-08, PVE-09, PVE-10, PVE-11
**Success Criteria** (what must be TRUE):
  1. User can view and modify VM configuration, resize disks, and clone VMs
  2. User can create, restore, and delete snapshots with confirmation prompts on destructive operations
  3. User can list cluster nodes, view recent tasks, back up VMs, and migrate VMs between nodes
**Plans**: TBD

Plans:
- [ ] 04-01: TBD
- [ ] 04-02: TBD

### Phase 5: Plex
**Goal**: Users can manage playlists, collections, streams, and server maintenance from the command line
**Depends on**: Phase 1
**Requirements**: PLEX-01, PLEX-02, PLEX-03, PLEX-04, PLEX-05, PLEX-06, PLEX-07, PLEX-08
**Success Criteria** (what must be TRUE):
  1. User can list playlists, collections, and shared users
  2. User can kill active streams and view transcode/bandwidth info for running sessions
  3. User can run server maintenance (optimize bundles, empty trash) and view server settings
**Plans**: TBD

Plans:
- [ ] 05-01: TBD

### Phase 6: Jellyfin
**Goal**: Users can manage users, scheduled tasks, plugins, and server info from the command line
**Depends on**: Phase 1
**Requirements**: JF-01, JF-02, JF-03, JF-04, JF-05, JF-06, JF-07, JF-08
**Success Criteria** (what must be TRUE):
  1. User can list, create, and delete Jellyfin users
  2. User can list and run scheduled tasks, and list installed plugins
  3. User can view activity logs and server info/configuration
**Plans**: TBD

Plans:
- [ ] 06-01: TBD

### Phase 7: qBittorrent
**Goal**: Users can inspect torrents in detail and manage priorities, speed limits, categories, and trackers from the command line
**Depends on**: Phase 1
**Requirements**: QBT-01, QBT-02, QBT-03, QBT-04, QBT-05, QBT-06, QBT-07, QBT-08, QBT-09, QBT-10
**Success Criteria** (what must be TRUE):
  1. User can view torrent details, file lists, trackers, and peers for any torrent
  2. User can set torrent priority, category, and move torrent files to a new location
  3. User can set global download and upload speed limits
**Plans**: TBD

Plans:
- [ ] 07-01: TBD

### Phase 8: AdGuard
**Goal**: Users can manage DHCP leases, DNS rewrites, clients, and filtering rules from the command line
**Depends on**: Phase 1
**Requirements**: AG-01, AG-02, AG-03, AG-04, AG-05, AG-06, AG-07, AG-08
**Success Criteria** (what must be TRUE):
  1. User can list DHCP leases and add static DHCP mappings
  2. User can list, add, and remove DNS rewrites
  3. User can remove custom allow/block rules, list clients, and view per-client stats
**Plans**: TBD

Plans:
- [ ] 08-01: TBD

### Phase 9: OPNsense
**Goal**: Users can manage firewall rules, aliases, DHCP, VPN tunnels, and traffic stats from the command line
**Depends on**: Phase 1
**Requirements**: OPN-01, OPN-02, OPN-03, OPN-04, OPN-05, OPN-06, OPN-07, OPN-08
**Success Criteria** (what must be TRUE):
  1. User can create, delete, and enable/disable firewall rules, and apply pending changes
  2. User can create aliases and add DHCP static mappings
  3. User can list VPN tunnels and view traffic stats
**Plans**: TBD

Plans:
- [ ] 09-01: TBD

### Phase 10: SABnzbd
**Goal**: Users can manage individual queue items, set priorities, control speed limits, and view server stats from the command line
**Depends on**: Phase 1
**Requirements**: SAB-01, SAB-02, SAB-03, SAB-04, SAB-05, SAB-06, SAB-07, SAB-08
**Success Criteria** (what must be TRUE):
  1. User can view NZB details, pause/resume individual items, and delete items with confirmation
  2. User can set queue item priority and list available categories
  3. User can set global speed limit and view server connection stats
**Plans**: TBD

Plans:
- [ ] 10-01: TBD

### Phase 11: Gluetun
**Goal**: Users can inspect VPN status, switch servers, and verify connection security from the command line
**Depends on**: Phase 1
**Requirements**: GLU-01, GLU-02, GLU-03, GLU-04, GLU-05, GLU-06
**Success Criteria** (what must be TRUE):
  1. User can view current VPN provider info, DNS config, and port forward status
  2. User can list available servers/regions and switch to a different server
  3. User can run a DNS leak test to verify VPN security
**Plans**: TBD

Plans:
- [ ] 11-01: TBD

### Phase 12: Overseerr
**Goal**: Users can manage requests in bulk, view users/quotas, and inspect service configuration from the command line
**Depends on**: Phase 1
**Requirements**: OVR-01, OVR-02, OVR-03, OVR-04, OVR-05
**Success Criteria** (what must be TRUE):
  1. User can bulk-approve all pending requests with a single command
  2. User can list users with quotas, view request details, list services, and view notification settings
**Plans**: TBD

Plans:
- [ ] 12-01: TBD

### Phase 13: Vault
**Goal**: Users can perform full CRUD on vault items, manage folders, generate passwords, and retrieve TOTP codes from the command line
**Depends on**: Phase 1
**Requirements**: BW-01, BW-02, BW-03, BW-04, BW-05, BW-06
**Success Criteria** (what must be TRUE):
  1. User can create, edit, and delete vault items with confirmation on delete
  2. User can list folders, generate passwords with configurable length, and retrieve TOTP codes
**Plans**: TBD

Plans:
- [ ] 13-01: TBD

### Phase 14: Firecrawl
**Goal**: Users can scrape with custom options, batch scrape, crawl with filters, and manage jobs from the command line
**Depends on**: Phase 1
**Requirements**: FC-01, FC-02, FC-03, FC-04, FC-05
**Success Criteria** (what must be TRUE):
  1. User can scrape a URL with custom wait time and headers, and batch scrape multiple URLs
  2. User can crawl with depth and filter options, cancel running jobs, and list recent jobs
**Plans**: TBD

Plans:
- [ ] 14-01: TBD

### Phase 15: Koel
**Goal**: Users can search, browse, and view stats for their music library via the Koel API from the command line
**Depends on**: Phase 1
**Requirements**: KOEL-01, KOEL-02, KOEL-03, KOEL-04, KOEL-05
**Success Criteria** (what must be TRUE):
  1. User can search the music library and view recently played tracks
  2. User can list playlists, browse albums/artists, and view library stats
**Plans**: TBD

Plans:
- [ ] 15-01: TBD

### Phase 16: Help Text
**Goal**: All CLI help texts accurately reflect every new command added in phases 1-15
**Depends on**: Phase 2, Phase 3, Phase 4, Phase 5, Phase 6, Phase 7, Phase 8, Phase 9, Phase 10, Phase 11, Phase 12, Phase 13, Phase 14, Phase 15
**Requirements**: HELP-01
**Success Criteria** (what must be TRUE):
  1. Running any CLI with `--help` or no arguments shows all available commands including every new command added in v2.0
  2. Every command listed in help text actually exists and works (no stale or missing entries)
**Plans**: TBD

Plans:
- [ ] 16-01: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> ... -> 16

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation | 0/2 | Planning complete | - |
| 2. Portainer | 0/3 | Planning complete | - |
| 3. ARR Suite | 0/3 | Planning complete | - |
| 4. Proxmox | 0/? | Not started | - |
| 5. Plex | 0/? | Not started | - |
| 6. Jellyfin | 0/? | Not started | - |
| 7. qBittorrent | 0/? | Not started | - |
| 8. AdGuard | 0/? | Not started | - |
| 9. OPNsense | 0/? | Not started | - |
| 10. SABnzbd | 0/? | Not started | - |
| 11. Gluetun | 0/? | Not started | - |
| 12. Overseerr | 0/? | Not started | - |
| 13. Vault | 0/? | Not started | - |
| 14. Firecrawl | 0/? | Not started | - |
| 15. Koel | 0/? | Not started | - |
| 16. Help Text | 0/? | Not started | - |
