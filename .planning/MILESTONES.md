# Milestones

## v2.0 Homelab CLI Suite (Shipped: 2026-03-22)

**Phases completed:** 16 phases, 34 plans, 62 tasks

**Key accomplishments:**

- confirm_action safety prompt and api_patch HTTP helper added to shared lib/common.sh
- Extracted resolve_container_id shared helper and added 5 stack commands (create from file/stdin, delete with confirmation, start-stack, stop-stack)
- Added update-env/edit stack commands and 5 container commands (stop-ct, start-ct, inspect with env masking, exec, top) completing container interaction without Portainer web UI
- Added 7 Docker resource commands (volumes, volume-rm, networks, images, pull, prune, endpoints) completing full Portainer CLI coverage with 26 total commands
- Add/delete/download/rename commands for Sonarr/Radarr/Lidarr with arr_api PUT and DELETE-with-body support
- 5 configuration commands (profiles, rootfolders, tags, tag-add, indexers) with formatted table output and CONFIGURATION help section
- Multi-method pve_api() with form-data passthrough, DRY start/stop/reboot, and 4 new VM management commands (config, set, resize, clone)
- Snapshot operations (create/restore/delete) with safety prompts and cluster listing commands (nodes, tasks) with formatted table output
- VM backup via vzdump with storage/compression options and cross-node migration with online/offline detection and confirmation prompt
- Multi-method plex_api with 4 new browsing commands: playlists, collections, shared users, and transcode/bandwidth details
- Stream kill with confirmation, async DB optimization, trash emptying, settings display, and fully reorganized help text covering all 16 commands
- User list/create/delete commands and scheduled task list/run commands for Jellyfin via REST API
- Plugin listing, activity log viewer, and server info display with comprehensive 17-command help text organized into 6 sections
- Torrent inspection commands (info, files, trackers, peers) with resolve_hash name-to-hash helper via qBittorrent WebAPI
- Torrent management commands (priority, categories, set-category, move) and dual-mode speed limit commands (limit-dl, limit-ul) with updated help text
- 5 new AdGuard commands for DHCP lease management and DNS rewrite CRUD via REST API
- Rule removal commands (unblock, unallow) and client inspection commands (clients, client) with updated help text covering all 24+ AdGuard commands
- 5 new commands for firewall rule CRUD (rule-add/rm/toggle), alias creation (alias-add), and two-phase commit apply workflow
- Static DHCP lease management, VPN tunnel status display, and live traffic rate monitoring with complete help text covering all 22+ OPNsense commands
- 5 queue item commands (info, delete, pause-item, resume-item, priority) using sab_api queue sub-actions with NZO ID targeting
- Categories listing, dual-mode speed limit management, and news server status via SABnzbd API
- 4 read-only VPN inspection commands (provider, servers, dns, ports) with server filtering and legacy port fallback
- VPN server switching by country/city via PUT /v1/vpn/settings and DNS leak testing via reverse DNS lookup against known VPN providers
- Bulk approve-all with confirmation, user listing with type/role mapping, and request-detail with media status and TV season display
- Service integration listing for Radarr/Sonarr with active/default/profile display, and notification agent viewer for 6 agents with enabled state and config summary
- CRUD item management commands (create/edit/delete) with template-based JSON construction and confirm_action safety on delete
- Folder listing, password generation with charset options, and TOTP code retrieval with countdown timer
- Enhanced scrape with --wait/--headers flags, new batch multi-URL command, and crawl with --depth/--include/--exclude filtering
- cmd_cancel with confirm_action safety gate and cmd_jobs with local cache + live API status queries for crawl/batch job tracking
- Koel REST API infrastructure with Bearer token auth and 3 library commands: search, playlists, recently played
- Library stats, album browsing with artist filter, artist listing, and complete help text with all 6 API commands
- Audit of all 14 CLI binaries confirmed perfect 1:1 correspondence between case statement commands and cmd_help() entries -- zero discrepancies found

---
