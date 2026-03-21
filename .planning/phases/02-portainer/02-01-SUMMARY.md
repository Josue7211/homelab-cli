---
phase: 02-portainer
plan: 01
subsystem: infra
tags: [portainer, docker, stacks, bash, api]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: confirm_action helper in lib/common.sh
provides:
  - resolve_container_id shared helper for container name-to-ID resolution
  - cmd_create for stack creation from file or stdin with optional env vars
  - cmd_delete_stack with confirmation prompt before deletion
  - cmd_start_stack and cmd_stop_stack for stack lifecycle management
affects: [02-portainer]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "resolve_container_id pattern mirrors resolve_stack_id for container name lookups"
    - "Stack CRUD commands follow existing pt_api_post/delete pattern with resolve_stack_id"

key-files:
  created: []
  modified:
    - bin/portainer

key-decisions:
  - "Kept python3 inline JSON construction for cmd_create payload to avoid jq dependency"
  - "Used --inline flag (reading from stdin via cat) for piped compose YAML input"

patterns-established:
  - "resolve_container_id: shared container resolution helper callable from any container command"
  - "confirm_action guard: all destructive stack operations use confirm_action before API call"

requirements-completed: [PT-20, PT-01, PT-02, PT-03, PT-04, PT-05]

# Metrics
duration: 2min
completed: 2026-03-21
---

# Phase 02 Plan 01: Portainer DRY Refactor + Stack CRUD Summary

**Extracted resolve_container_id shared helper and added 5 stack commands (create from file/stdin, delete with confirmation, start-stack, stop-stack)**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-21T17:28:06Z
- **Completed:** 2026-03-21T17:29:59Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Eliminated duplicated 10-line python container ID resolution block from cmd_logs and cmd_restart into single resolve_container_id helper
- Added cmd_create with dual modes: -f/--file for local compose files and --inline for stdin piped YAML, both with optional --env K=V support
- Added cmd_delete_stack with confirm_action safety gate before destructive DELETE API call
- Added cmd_start_stack and cmd_stop_stack for full stack lifecycle management

## Task Commits

Each task was committed atomically:

1. **Task 1: Extract resolve_container_id helper and refactor cmd_logs + cmd_restart** - `ce6654c` (refactor)
2. **Task 2: Add stack CRUD commands -- create, delete, start-stack, stop-stack** - `b24192d` (feat)

## Files Created/Modified
- `bin/portainer` - Added resolve_container_id helper, refactored cmd_logs/cmd_restart, added 4 new command functions (cmd_create, cmd_delete_stack, cmd_start_stack, cmd_stop_stack), updated main() case statement and cmd_help()

## Decisions Made
- Kept python3 inline for JSON payload construction in cmd_create (consistent with existing codebase, avoids jq dependency)
- Used environment variable passing to python3 for safe JSON escaping of compose content and stack name

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Known Stubs

None - all commands are fully wired to Portainer API endpoints.

## Next Phase Readiness
- resolve_container_id helper available for future container commands (inspect, exec, etc.)
- Stack CRUD complete, ready for Plan 02 (container operations) and Plan 03 (resource management)

## Self-Check: PASSED

- SUMMARY.md: exists
- bin/portainer: exists
- ce6654c (Task 1 commit): exists
- b24192d (Task 2 commit): exists

---
*Phase: 02-portainer*
*Completed: 2026-03-21*
