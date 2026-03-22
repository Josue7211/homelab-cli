---
phase: 03-arr-suite
plan: 01
subsystem: cli
tags: [bash, arr, sonarr, radarr, lidarr, crud, media-management]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: confirm_action helper in lib/common.sh, api_put in lib/common.sh
provides:
  - cmd_add for adding series/movies/artists to Sonarr/Radarr/Lidarr
  - cmd_delete with confirmation prompt for safe deletion
  - cmd_download triggering search commands per app
  - cmd_rename triggering rename commands per app
  - arr_api PUT and DELETE-with-body support
affects: [03-arr-suite]

# Tech tracking
tech-stack:
  added: []
  patterns: [python3 JSON payload construction via env vars, app-specific command dispatch]

key-files:
  created: []
  modified: [bin/arr]

key-decisions:
  - "Auto-fetch first quality profile and root folder when not specified in cmd_add"
  - "Lidarr rename uses RenameFiles command (not RenameArtist) per Lidarr API spec"
  - "All library management commands guard against Prowlarr/Bazarr with clear error messages"

patterns-established:
  - "Library management commands: validate app in media-only guard, build per-app payload, call arr_api"
  - "Python3 env var JSON construction: pass shell vars via env to avoid escaping issues"

requirements-completed: [ARR-01, ARR-02, ARR-03, ARR-04]

# Metrics
duration: 6min
completed: 2026-03-22
---

# Phase 03 Plan 01: Library Management Summary

**Add/delete/download/rename commands for Sonarr/Radarr/Lidarr with arr_api PUT and DELETE-with-body support**

## Performance

- **Duration:** 6 min
- **Started:** 2026-03-22T07:33:05Z
- **Completed:** 2026-03-22T07:39:13Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added arr_api() PUT support and DELETE-with-body for JSON payload operations
- Implemented cmd_add() with auto-fetching quality profiles and root folders when not specified
- Implemented cmd_delete() with confirm_action safety prompt before API deletion
- Implemented cmd_download() triggering per-app search commands (SeriesSearch/MoviesSearch/ArtistSearch)
- Implemented cmd_rename() triggering per-app rename commands (RenameSeries/RenameMovie/RenameFiles)
- All 4 commands wired into main case statement, app-shortcut fallback, and help text

## Task Commits

Each task was committed atomically:

1. **Task 1: Enhance arr_api for PUT/DELETE-with-body + add cmd_add and cmd_delete** - `51e8875` (feat)
2. **Task 2: Add cmd_download and cmd_rename commands** - `86a510c` (feat)

## Files Created/Modified
- `bin/arr` - Added 4 library management commands (cmd_add, cmd_delete, cmd_download, cmd_rename), enhanced arr_api with PUT/DELETE-with-body, updated help text

## Decisions Made
- Auto-fetch first quality profile and root folder from API when user doesn't specify --quality/--root (convenience default)
- Lidarr rename uses RenameFiles command name (not RenameArtist) matching Lidarr's actual API command names
- All library management commands enforce media-apps-only guard (sonarr/radarr/lidarr), rejecting prowlarr/bazarr with clear messages
- delete uses deleteFiles=true query param for complete cleanup

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
- NFS mount on /mnt/storage prevents git from creating objects (NFS rejects O_CREAT|O_EXCL with 0444 mode). Worked around by using a local /tmp clone for git operations. All commits are in the local clone and need to be synced.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Library management commands complete, ready for Plan 02 (configuration listing commands)
- arr_api now supports GET/POST/PUT/DELETE with full body support for all future commands

---
*Phase: 03-arr-suite*
*Completed: 2026-03-22*
