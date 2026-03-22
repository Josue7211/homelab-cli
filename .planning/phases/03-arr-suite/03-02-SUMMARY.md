---
phase: 03-arr-suite
plan: 02
subsystem: cli
tags: [bash, arr, sonarr, radarr, lidarr, prowlarr, qualityprofile, rootfolder, tag, indexer]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: common.sh helpers (info, ok, warn, die, confirm_action)
  - phase: 03-arr-suite plan 01
    provides: arr_api pattern, Library Management section, app registry
provides:
  - cmd_profiles listing quality profiles with ID/name/cutoff/items
  - cmd_rootfolders listing root folders with path/free-space
  - cmd_tags listing tags with ID/label
  - cmd_tag_add creating tags via POST
  - cmd_indexers listing indexers across one or all apps
affects: [03-arr-suite]

# Tech tracking
tech-stack:
  added: []
  patterns: [configuration-listing-pattern, all-apps-iteration-for-indexers]

key-files:
  created: []
  modified: [bin/arr]

key-decisions:
  - "Profiles/rootfolders limited to sonarr/radarr/lidarr -- prowlarr/bazarr lack these endpoints"
  - "Tags support prowlarr (has /tag endpoint) but not bazarr"
  - "Indexers iterate ALL_APPS when no app specified for cross-app overview"

patterns-established:
  - "Configuration listing commands: guard app support with case, call arr_api GET, format with python3 inline"
  - "CONFIGURATION help section for non-CRUD read-only config commands"

requirements-completed: [ARR-05, ARR-06, ARR-07, ARR-08, ARR-09]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 3 Plan 2: ARR Configuration Listing Summary

**5 configuration commands (profiles, rootfolders, tags, tag-add, indexers) with formatted table output and CONFIGURATION help section**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T07:42:20Z
- **Completed:** 2026-03-22T07:45:15Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Quality profiles listing with ID, name, cutoff resolution, and allowed item count
- Root folders listing with path and free space in GB
- Tags listing and creation (including Prowlarr support)
- Indexers listing across all apps with name, protocol, and enabled status
- CONFIGURATION section added to help text with all 5 commands and examples

## Task Commits

Each task was committed atomically:

1. **Task 1: Add cmd_profiles, cmd_rootfolders, and cmd_tags** - `3d5da23` (feat)
2. **Task 2: Add cmd_tag_add, cmd_indexers and update help** - `205cdca` (feat)

## Files Created/Modified
- `bin/arr` - Added 5 configuration listing/creation commands, wired into main case + app-shortcut fallback, CONFIGURATION help section

## Decisions Made
- Profiles and rootfolders guard to sonarr/radarr/lidarr only (prowlarr and bazarr lack these endpoints)
- Tags commands support prowlarr in addition to the three media apps (prowlarr has /tag endpoint)
- Indexers command iterates ALL_APPS (including bazarr) when no app argument provided, with graceful "could not connect" fallback
- cmd_profiles resolves cutoff name by searching quality items and sub-items for matching quality ID

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
- NFS mount prevents direct git commits due to read-only object mode; used /tmp clone workaround to commit and sync pack files back

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- All configuration listing commands complete
- Ready for Phase 3 Plan 3 (maintenance operations: blocklist, backup, logs, restart)
- bin/arr now has 16 commands covering dashboard, queue, library, library management, and configuration

## Self-Check: PASSED

- All files exist (bin/arr, 03-02-SUMMARY.md)
- Both commits found (3d5da23, 205cdca)
- All 5 functions present (cmd_profiles, cmd_rootfolders, cmd_tags, cmd_tag_add, cmd_indexers)
- No stubs or placeholders found

---
*Phase: 03-arr-suite*
*Completed: 2026-03-22*
