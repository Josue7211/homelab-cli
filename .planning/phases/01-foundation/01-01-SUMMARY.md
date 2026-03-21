---
phase: 01-foundation
plan: 01
subsystem: infra
tags: [bash, curl, helpers, shared-library]

# Dependency graph
requires: []
provides:
  - "confirm_action() destructive operation safety prompt in lib/common.sh"
  - "api_patch() PATCH HTTP method helper in lib/common.sh"
affects: [02-portainer, 03-arr, 04-plex, 05-jellyfin, 06-adguard, 07-qbittorrent, 08-sabnzbd, 09-overseerr, 10-gluetun, 11-koel, 12-firecrawl, 13-vault, 14-opnsense, 15-homelab]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "confirm_action for all destructive CLI operations with HOMELAB_YES=1 bypass"
    - "api_patch follows same 3-param pattern as api_put (url, api_key, data)"

key-files:
  created: []
  modified:
    - lib/common.sh

key-decisions:
  - "Placed confirm_action in Output helpers section (user-facing prompt helper)"
  - "api_patch mirrors api_put exactly with PATCH method for consistency"

patterns-established:
  - "HOMELAB_YES=1 env var skips all confirmation prompts for scripting"
  - "All HTTP method helpers use consistent (url, api_key, data) signature"

requirements-completed: [LIB-01, LIB-02]

# Metrics
duration: 1min
completed: 2026-03-21
---

# Phase 01 Plan 01: Common Library Helpers Summary

**confirm_action safety prompt and api_patch HTTP helper added to shared lib/common.sh**

## Performance

- **Duration:** 1 min
- **Started:** 2026-03-21T16:24:09Z
- **Completed:** 2026-03-21T16:25:08Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added confirm_action() with "Are you sure? (y/N)" prompt, defaults to abort, respects HOMELAB_YES=1 for scripting
- Added api_patch() following the exact same pattern as api_put() but using PATCH HTTP method
- Verified all 14 existing CLI scripts still parse without syntax errors

## Task Commits

Each task was committed atomically:

1. **Task 1: Add confirm_action and api_patch helpers to lib/common.sh** - `00d370d` (feat)
2. **Task 2: Verify helpers work with existing CLIs** - no file changes (verification-only task)

## Files Created/Modified
- `lib/common.sh` - Added confirm_action() and api_patch() helper functions (24 lines added)

## Decisions Made
- Placed confirm_action after header() in the Output helpers section since it's a user-facing prompt helper
- api_patch mirrors api_put exactly (same parameter signature, same header handling) with only the HTTP method changed

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- confirm_action ready for all delete/prune/clear commands across phases 2-15
- api_patch ready for PATCH API endpoints across all service CLIs
- All existing CLIs unaffected, safe to proceed with any phase

## Self-Check: PASSED

- FOUND: lib/common.sh
- FOUND: 01-01-SUMMARY.md
- FOUND: commit 00d370d
- FOUND: confirm_action in common.sh
- FOUND: api_patch in common.sh

---
*Phase: 01-foundation*
*Completed: 2026-03-21*
