---
phase: 15-koel
plan: 01
subsystem: api
tags: [koel, music, bearer-auth, rest-api, search, playlists]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: common.sh helpers (die, header, format_table, info, ok, warn)
provides:
  - koel_api() multi-method API helper with Bearer token auth
  - koel_login() and koel_token() with 24-hour caching
  - cmd_search for songs/albums/artists search
  - cmd_playlists for playlist listing
  - cmd_recent for recently played tracks
affects: [15-koel]

# Tech tracking
tech-stack:
  added: []
  patterns: [koel Bearer token auth via POST /api/me, token file caching with 24h TTL]

key-files:
  created: []
  modified: [bin/koel]

key-decisions:
  - "Token caching uses find -mmin -1440 for 24-hour TTL check"
  - "Search results grouped into SONGS/ALBUMS/ARTISTS sections with (none) fallback"
  - "Playlists piped through format_table for column alignment"

patterns-established:
  - "koel_api(method, path, data): Bearer token auth pattern for all Koel API commands"
  - "koel_token(): cached token with automatic refresh via koel_login()"

requirements-completed: [KOEL-01, KOEL-02, KOEL-03]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 15 Plan 01: Koel API Helpers and Library Commands Summary

**Koel REST API infrastructure with Bearer token auth and 3 library commands: search, playlists, recently played**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T12:34:28Z
- **Completed:** 2026-03-22T12:36:33Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added koel_login/koel_token/koel_api helper infrastructure with Bearer token auth and 24-hour token caching
- Added cmd_search querying /api/search with grouped display of songs, albums, and artists
- Added cmd_playlists querying /api/playlist with ID/name/songs/owner table
- Added cmd_recent querying /api/interaction/recently-played with up to 20 tracks

## Task Commits

Each task was committed atomically:

1. **Task 1: Add koel_login, koel_api helpers and search/playlists commands** - `ea8bab0` (feat)
2. **Task 2: Add recently-played command** - `4102cef` (feat)

## Files Created/Modified
- `bin/koel` - Added API auth helpers (koel_login, koel_token, koel_api) and 3 new commands (search, playlists, recent) with LIBRARY help section

## Decisions Made
- Token caching uses `find -mmin -1440` for 24-hour TTL check (Koel tokens are long-lived)
- Search results displayed in grouped sections (SONGS, ALBUMS, ARTISTS) with `(none)` fallback for empty categories
- Playlists output piped through `format_table` for consistent column alignment
- cmd_recent handles both song objects and nested structures for Koel API version compatibility
- Help text updated with new LIBRARY section between STATUS and DEPLOYMENT

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
Users must set `KOEL_EMAIL` and `KOEL_PASS` in `~/.config/homelab-cli/config` for API authentication.

## Next Phase Readiness
- API infrastructure (koel_api, koel_login, koel_token) ready for Plan 02 to add stats, albums, artists commands
- Bearer token pattern established for all future Koel API commands

## Self-Check: PASSED

- bin/koel: FOUND
- 15-01-SUMMARY.md: FOUND
- Commit ea8bab0 (Task 1): FOUND
- Commit 4102cef (Task 2): FOUND

---
*Phase: 15-koel*
*Completed: 2026-03-22*
