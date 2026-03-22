---
phase: 04-proxmox
plan: 03
subsystem: api
tags: [proxmox, bash, curl, pve-api, backup, migrate, vzdump, cluster]

# Dependency graph
requires:
  - phase: 04-proxmox
    provides: pve_api multi-method, _resolve_vm_type, confirm_action, cmd_nodes, cmd_tasks
provides:
  - cmd_backup for triggering vzdump backups with configurable storage and compression
  - cmd_migrate for migrating VMs between nodes with online/offline detection and confirmation
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns: [vzdump via POST /nodes/{node}/vzdump with vmid as form param, online migration detection via VM status check]

key-files:
  created: []
  modified: [bin/homelab]

key-decisions:
  - "vzdump endpoint is /nodes/{node}/vzdump (not nested under VM type) with vmid as form parameter"
  - "Backup defaults to zstd compression and snapshot mode for online-safe operation"
  - "Migrate checks VM running status to set online=1 flag and report migration type in confirm prompt"

patterns-established:
  - "Async operations (backup, migrate, clone) report UPID and suggest homelab tasks for tracking"
  - "Destructive cluster operations (migrate) use confirm_action with descriptive context"

requirements-completed: [PVE-10, PVE-11]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 4 Plan 3: Proxmox Backup & Migration Summary

**VM backup via vzdump with storage/compression options and cross-node migration with online/offline detection and confirmation prompt**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T08:41:29Z
- **Completed:** 2026-03-22T08:43:11Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added cmd_backup with --storage and --compress flags, defaulting to zstd compression and snapshot mode
- Added cmd_migrate with VM status detection for online/offline migration and confirm_action safety prompt
- Both commands report UPID for tracking and suggest `homelab tasks` follow-up
- All 11 PVE requirement commands now implemented and validated

## Task Commits

Each task was committed atomically:

1. **Task 1: Add backup and migrate commands** - `f56a45b` (feat)
2. **Task 2: Final validation and syntax check** - no commit (validation-only, no changes needed)

## Files Created/Modified
- `bin/homelab` - Added cmd_backup (vzdump trigger), cmd_migrate (cross-node migration), main() entries, CLUSTER help section updates, EXAMPLES additions

## Decisions Made
- vzdump endpoint is `/nodes/{node}/vzdump` with vmid passed as form data (not nested under VM type path)
- Backup defaults to zstd compression and snapshot mode for safe online backups (per D-14)
- Migrate checks VM status via `/status/current` endpoint to determine online vs offline migration type
- Migration requires confirm_action with migration type shown in the prompt (per D-15)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All 11 Proxmox commands complete: config, set, resize, clone, snapshot-create/restore/delete, nodes, tasks, backup, migrate
- Phase 04-proxmox fully done, ready for next phase
- confirm_action pattern used consistently across all destructive operations (snapshot-restore, snapshot-delete, migrate)

## Self-Check: PASSED

- FOUND: bin/homelab
- FOUND: f56a45b (Task 1 commit)
- FOUND: 04-03-SUMMARY.md

---
*Phase: 04-proxmox*
*Completed: 2026-03-22*
