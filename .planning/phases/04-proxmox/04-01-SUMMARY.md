---
phase: 04-proxmox
plan: 01
subsystem: api
tags: [proxmox, bash, curl, pve-api, vm-management]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: common.sh helpers (info, ok, die, header, confirm_action, get_secret)
provides:
  - Multi-method pve_api() supporting GET/POST/PUT/DELETE with form-data passthrough
  - cmd_config for viewing VM configuration grouped by category
  - cmd_set for modifying VM configuration via KEY=VAL pairs
  - cmd_resize for resizing VM disks
  - cmd_clone for full-cloning VMs with optional --name/--target
affects: [04-proxmox]

# Tech tracking
tech-stack:
  added: []
  patterns: [pve_api method-first signature, form-encoded data via curl -d passthrough]

key-files:
  created: []
  modified: [bin/homelab]

key-decisions:
  - "pve_api takes method as first arg with passthrough curl args for form data"
  - "cmd_clone creates full clones (not linked) for portability"

patterns-established:
  - "pve_api method-first: all Proxmox API calls use pve_api METHOD path [curl-args]"
  - "Form data passthrough: extra args after path passed directly to curl (-d key=val)"

requirements-completed: [PVE-01, PVE-02, PVE-03, PVE-04]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 4 Plan 1: Proxmox VM Management Summary

**Multi-method pve_api() with form-data passthrough, DRY start/stop/reboot, and 4 new VM management commands (config, set, resize, clone)**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T08:33:29Z
- **Completed:** 2026-03-22T08:35:51Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Refactored pve_api() from GET-only to multi-method (GET/POST/PUT/DELETE) with curl argument passthrough for form-encoded data
- Eliminated all raw curl POST calls by refactoring cmd_start, cmd_stop, cmd_reboot to use pve_api POST
- Added 4 new VM management commands: config (grouped key-value display), set (KEY=VAL modification), resize (disk resizing), clone (full clone with --name/--target)
- All commands wired into main() case statement and VM MANAGEMENT help section

## Task Commits

Each task was committed atomically:

1. **Task 1: Refactor pve_api to support methods + form data, DRY existing commands** - `97ba7f8` (refactor)
2. **Task 2: Add VM configuration commands (config, set, resize, clone)** - `d262df7` (feat)

## Files Created/Modified
- `bin/homelab` - Extended pve_api(), refactored start/stop/reboot, added config/set/resize/clone commands and VM MANAGEMENT help section

## Decisions Made
- pve_api takes method as first positional arg (GET default), remaining args passed through to curl for form-encoded data (-d key=val)
- cmd_clone creates full clones (full=1) rather than linked clones for portability
- cmd_config groups keys by category (CPU, memory, disk, network, other) with digest key filtered out
- cmd_set requires no confirmation (reversible config changes)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- pve_api multi-method foundation ready for snapshot operations (plan 02) and cluster operations (plan 03)
- All new commands use pve_api POST/PUT, establishing the pattern for remaining commands

## Self-Check: PASSED

- FOUND: bin/homelab
- FOUND: 97ba7f8 (Task 1 commit)
- FOUND: d262df7 (Task 2 commit)
- FOUND: 04-01-SUMMARY.md

---
*Phase: 04-proxmox*
*Completed: 2026-03-22*
