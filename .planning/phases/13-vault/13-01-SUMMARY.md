---
phase: 13-vault
plan: 01
subsystem: cli
tags: [bash, bitwarden, vaultwarden, bw-cli, crud]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: common.sh helpers (confirm_action, die, ok, info)
provides:
  - cmd_create for login item creation with template-based JSON construction
  - cmd_edit for patching existing item fields via bw edit
  - cmd_delete with confirm_action safety gate
  - resolve_item_id helper for name-or-UUID resolution
affects: [13-vault]

# Tech tracking
tech-stack:
  added: []
  patterns: [base64-encode via python3 instead of bw encode, _UNSET_ sentinel for optional edit fields]

key-files:
  created: []
  modified: [bin/vault]

key-decisions:
  - "Used python3 base64 encoding inline rather than piping to bw encode for simpler pipeline"
  - "resolve_item_id extracts as shared helper used by edit and delete"
  - "delete|rm alias for consistency with other CLIs (e.g., Jellyfin user-rm)"

patterns-established:
  - "resolve_item_id: UUID regex check then bw get item name lookup for name-to-ID resolution"
  - "_UNSET_ sentinel pattern for optional edit fields to distinguish 'not provided' from empty string"

requirements-completed: [BW-01, BW-02, BW-03]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 13 Plan 01: Vault Item Management Summary

**CRUD item management commands (create/edit/delete) with template-based JSON construction and confirm_action safety on delete**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T11:55:50Z
- **Completed:** 2026-03-22T11:58:06Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added resolve_item_id helper for UUID detection and name-to-ID lookup via bw CLI
- Implemented cmd_create with bw template + python3/os.environ JSON construction, supporting --url and --folder flags
- Implemented cmd_edit with field-level patching (username/password/url/notes) using _UNSET_ sentinel pattern
- Implemented cmd_delete with confirm_action confirmation before permanent deletion
- Updated help text with LOOKUP/ITEM MANAGEMENT/SYNC sections and usage examples

## Task Commits

Each task was committed atomically:

1. **Task 1: Add item creation and edit commands** - `4eb5fa9` (feat)
2. **Task 2: Add delete command with confirmation** - `dac86c4` (feat)

## Files Created/Modified
- `bin/vault` - Added resolve_item_id, cmd_create, cmd_edit, cmd_delete functions; updated case statement and help text (+182 lines)

## Decisions Made
- Used python3 base64.b64encode inline instead of piping through `bw encode` binary for simpler single-pipeline construction
- resolve_item_id extracted as shared helper (used by cmd_edit and cmd_delete) rather than duplicating UUID/name resolution
- delete|rm alias matches other CLIs in the project (e.g., Jellyfin user-rm)
- Help text reorganized into LOOKUP/ITEM MANAGEMENT/SYNC sections following established pattern from other CLIs

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Item CRUD lifecycle complete (create/edit/delete) alongside existing read commands (get/item/search/list)
- Ready for Plan 02 which adds utility commands (folders, generate, totp)

---
*Phase: 13-vault*
*Completed: 2026-03-22*
