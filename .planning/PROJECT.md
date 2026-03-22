# Homelab CLI

## What This Is

A suite of 14 bash CLIs for managing a self-hosted homelab infrastructure — Proxmox VMs, Docker containers via Portainer, media servers (Plex, Jellyfin), download clients (qBittorrent, SABnzbd), DNS ad-blocking (AdGuard Home), media automation (*ARR suite), VPN (Gluetun), firewall (OPNsense), and more. All CLIs share a common library for API calls, secret retrieval via Vaultwarden, and formatted output.

## Core Value

Every homelab operation available in a web UI can be performed from the command line, discoverable by AI agents via OpenCLI.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

- ✓ Portainer: list stacks, containers, logs, restart, redeploy, compose, env — v1.0
- ✓ Portainer: create, delete, start/stop stacks, update-env, edit, stop/start containers, inspect, exec, top, volumes, volume-rm, networks, images, pull, prune, endpoints — v2.0 (Phase 2)
- ✓ ARR: status, queue, queue-clear, activity, calendar, search, library, wanted, health, diskspace, system — v1.0
- ✓ Proxmox/Homelab: status, vms, vm, start, stop, reboot, snapshots, storage — v1.0
- ✓ Plex: status, streams, libraries, recent, search, history, users, scan — v1.0
- ✓ Jellyfin: status, streams, libraries, recent, search, scan, devices, logs — v1.0
- ✓ AdGuard: status, stats, filters, enable/disable-filter, refresh, log, blocked, rules, allow, block, top-blocked, top-clients, protect-on/off — v1.0
- ✓ qBittorrent: status, speed, list, add, pause, resume, delete — v1.0
- ✓ SABnzbd: status, speed, queue, history, add, pause, resume — v1.0
- ✓ Overseerr: status, requests, search, request, approve, decline, delete, media — v1.0
- ✓ Gluetun: status, ip, port, start, stop, restart — v1.0
- ✓ Koel: status, open, deploy, restart, compose, env, artisan, scan, bash, shell, logs, db-logs, db — v1.0
- ✓ Firecrawl: scrape, crawl, status, map, search, extract, health — v1.0
- ✓ Vault: status, get, user, item, search, list, sync — v1.0
- ✓ OPNsense: status, gateways, interfaces, dhcp, rules, aliases, firmware, update-check, services, restart, arp, dns, backup — v1.0
- ✓ Common library: api_get/post/put/delete, get_secret (bw/env/file/config/value), format_table, human_size — v1.0

### Active

<!-- Current scope. Building toward these. -->

See REQUIREMENTS.md for detailed REQ-IDs.

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- GUI/TUI interfaces — CLIs are terminal-first, no ncurses
- Multi-user auth — single operator, Vaultwarden handles secrets
- Windows support — bash-only, Linux/macOS
- Automated scheduling — use cron, not built-in schedulers
- Web scraping the service UIs — use REST APIs exclusively

## Context

- **Infrastructure:** Proxmox VE cluster with 2 VMs — Services (10.0.0.109) and Plex/Media (10.0.0.153)
- **Networking:** OPNsense firewall (10.0.0.1), AdGuard Home DNS (10.0.0.10), Cloudflare tunnel
- **Secrets:** All API keys/tokens stored in Vaultwarden, retrieved via `bw` CLI at runtime
- **Portainer:** Two instances — Services (HTTPS/9443) and Plex (HTTP/9000) — with API key auth
- **ARR Suite:** API keys auto-retrieved from config.xml via SSH to Plex VM
- **Current coverage:** ~95% API coverage across all 14 CLIs — full CRUD operations, management commands, and help text for every service
- **User preference:** Never manage containers via CLI directly — always use Portainer API (even for container operations)

## Constraints

- **Auth:** All secrets via Vaultwarden `bw` CLI — no hardcoded credentials (except OPNsense API key/secret in config)
- **Dependencies:** bash, curl, python3, jq (optional) — no npm/pip packages
- **API-first:** All operations via REST APIs — no SSH/docker exec except Koel (legacy)
- **Portainer-mediated:** Container/stack operations go through Portainer API, not Docker API directly
- **Non-destructive defaults:** Dangerous operations (delete, prune) require explicit confirmation or flags

## Current State: v2.0 Shipped

**Shipped:** 2026-03-22
**Phases:** 16 | **Plans:** 34 | **Commands added:** ~130 new commands across 14 CLIs
**Code:** 10,526 lines of bash across 14 CLI binaries + shared library

All 14 CLIs now have comprehensive API coverage including CRUD operations, management commands, and organized help text. 125/128 requirements satisfied. 3 OpenCLI registration requirements deferred (external tooling dependency).

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Bash over TypeScript/Python | Consistency with existing codebase, zero dependencies beyond curl/python3 | ✓ Good |
| Extend existing CLIs vs OpenCLI adapters | Services are REST APIs — bash curl wrappers are simpler than browser automation | ✓ Good |
| Portainer API over Docker API | User preference, consistent with existing workflow | ✓ Good |
| Register with OpenCLI for discovery | AI agents can find tools via `opencli list` | ⚠️ Deferred (external tooling) |
| Inline python3 for JSON parsing | Avoids jq dependency, consistent pattern across all CLIs | ✓ Good |
| confirm_action on destructive ops | Safety net for delete/remove/cancel commands | ✓ Good |
| resolve_*_id helpers | Name-to-ID lookup enables friendly command interfaces | ✓ Good |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-22 after v2.0 milestone completion*
