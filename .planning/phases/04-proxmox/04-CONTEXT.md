# Phase 4: Proxmox - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 11 new commands to the homelab CLI for VM configuration management (config, set, resize, clone), snapshot operations (snapshot-create, snapshot-restore, snapshot-delete), and cluster operations (nodes, tasks, backup, migrate). All commands use the Proxmox VE API via PVEAPIToken auth.

</domain>

<decisions>
## Implementation Decisions

### API helper refactor
- **D-01:** Extend `pve_api()` to accept method parameter: `pve_api <method> <path> [data]`. Default method is GET for backward compatibility with existing callers.
- **D-02:** Refactor existing `cmd_start`, `cmd_stop`, `cmd_reboot` to use the new `pve_api POST` instead of raw curl calls. This DRYs up the auth header construction.
- **D-03:** Support POST with form data (Proxmox uses `application/x-www-form-urlencoded` for most mutations, not JSON like ARR/Portainer APIs).

### VM configuration
- **D-04:** `homelab config <vmid>` shows full VM config via GET `/nodes/{node}/{type}/{vmid}/config`. Display as key-value pairs, grouped by category (CPU, memory, disk, network, other).
- **D-05:** `homelab set <vmid> KEY=VAL...` uses PUT `/nodes/{node}/{type}/{vmid}/config` with form-encoded key-value pairs. No confirmation prompt needed — config changes are reversible.
- **D-06:** `homelab resize <vmid> <disk> <size>` uses PUT `/nodes/{node}/{type}/{vmid}/resize` with `disk=<disk>&size=<size>`. Size format follows Proxmox convention (e.g., `+10G`).

### Clone behavior
- **D-07:** `homelab clone <vmid>` creates a full clone (not linked) for portability. Auto-assigns new VMID by Proxmox (use `newid` parameter omitted = next available). Returns immediately with task info.
- **D-08:** Supports `--name <name>` to set the clone's name, and `--target <node>` to clone to a different node. Defaults: name derived by Proxmox, target is same node.

### Snapshot operations
- **D-09:** `snapshot-create <vmid> <name>` uses POST with description optional via `--desc`. No confirmation needed.
- **D-10:** `snapshot-restore <vmid> <name>` requires `confirm_action` — restoring a snapshot is destructive (current state lost).
- **D-11:** `snapshot-delete <vmid> <name>` requires `confirm_action` — snapshot deletion is irreversible.

### Cluster operations
- **D-12:** `homelab nodes` lists all cluster nodes via GET `/cluster/resources?type=node` showing name, status, CPU, memory, uptime.
- **D-13:** `homelab tasks [count]` lists recent cluster tasks via GET `/cluster/tasks` with configurable count (default 20). Shows UPID, type, status, start time, node.
- **D-14:** `homelab backup <vmid>` triggers vzdump via POST `/nodes/{node}/{type}/{vmid}/vzdump`. Uses default backup storage. Supports `--storage <name>` override and `--compress <algo>` (default: zstd).
- **D-15:** `homelab migrate <vmid> <node>` requires `confirm_action`. Uses POST `/nodes/{node}/{type}/{vmid}/migrate` with `target=<node>`. Online migration for running VMs.

### Claude's Discretion
- Exact formatting of config output (key-value alignment, grouping)
- Task list column layout
- Progress/status messages for async operations (backup, migrate, clone)

</decisions>

<specifics>
## Specific Ideas

- Proxmox API uses form-encoded POST bodies (not JSON) — `pve_api` needs `-d` key=value pairs, not `-H Content-Type: application/json`
- Backup should report the UPID so user can track with `homelab tasks`
- Migrate should mention whether it's online (running VM) or offline

</specifics>

<canonical_refs>
## Canonical References

No external specs — requirements are fully captured in decisions above and REQUIREMENTS.md (PVE-01 through PVE-11).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/homelab` — 8 existing commands: status, vms, vm, start, stop, reboot, snapshots, storage
- `pve_api()` — GET-only API wrapper with PVEAPIToken auth (needs method extension)
- `get_pve_token()` — cached token retrieval from Vaultwarden
- `_resolve_vm_type()` — resolves VMID to `qemu` or `lxc` type
- `lib/common.sh` — confirm_action, api_get/post/put/delete, color helpers

### Established Patterns
- PVEAPIToken auth: `-H "Authorization: PVEAPIToken=${PVE_TOKEN}=${token}"`
- Node variable: `$PVE_NODE` (defaults to "pve")
- All Proxmox API paths start with `/nodes/{PVE_NODE}/{vm_type}/{vmid}/`
- Python3 inline for JSON parsing and table formatting
- `die` for fatal errors, `info`/`ok` for status messages

### Integration Points
- All new commands added to bin/homelab main() case statement
- Help text updated in cmd_help() with new sections (VM MANAGEMENT, SNAPSHOTS, CLUSTER)
- Proxmox API: /nodes/{node}/{type}/{vmid}/config, /snapshot, /resize, /clone, /vzdump, /migrate
- Cluster API: /cluster/resources, /cluster/tasks

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 04-proxmox*
*Context gathered: 2026-03-22*
