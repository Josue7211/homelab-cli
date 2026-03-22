---
phase: 13-vault
plan: 02
subsystem: cli
tags: [bash, bitwarden, vaultwarden, bw-cli, folders, totp, password-generator]

# Dependency graph
requires:
  - phase: 13-vault-01
    provides: check_unlocked, resolve_item_id, cmd_create/edit/delete in bin/vault
  - phase: 01-foundation
    provides: common.sh helpers (header, die, ok, BOLD/RESET colors)
provides:
  - cmd_folders for listing all vault folders with ID and name
  - cmd_generate for password generation with configurable length and character options
  - cmd_totp for retrieving current TOTP code with remaining seconds display
  - Updated help text with STATUS, LOOKUP, ITEM MANAGEMENT, UTILITIES, EXAMPLES, NOTE sections
affects: [13-vault]

# Tech tracking
tech-stack:
  added: []
  patterns: [python3 time.time() for TOTP countdown, bw generate flag passthrough]

key-files:
  created: []
  modified: [bin/vault]

key-decisions:
  - "TOTP remaining seconds calculated via python3 time module (30 - epoch % 30) for standard 30s rotation"
  - "cmd_generate uses bw generate with passthrough charset flags (-ulns, -uln, -n) rather than reimplementing generation"
  - "Help text reorganized into 6 sections (STATUS, LOOKUP, ITEM MANAGEMENT, UTILITIES, EXAMPLES, NOTE) following established project pattern"

patterns-established:
  - "bw generate charset flag mapping: -ulns (all), -uln (no symbols), -n (numbers only)"
  - "TOTP countdown display: code + remaining seconds until rotation"

requirements-completed: [BW-04, BW-05, BW-06]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 13 Plan 02: Vault Utilities Summary

**Folder listing, password generation with charset options, and TOTP code retrieval with countdown timer**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T12:00:52Z
- **Completed:** 2026-03-22T12:02:24Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Added cmd_folders to list all vault folders with ID and name, including "(no folder)" reminder for unorganized items
- Added cmd_generate wrapping bw generate with --length (default 20), --no-symbols, and --numbers-only options
- Added cmd_totp to retrieve current TOTP code and display remaining seconds until rotation
- Reorganized help text into 6 sections with all 9 commands (6 new from Plans 01+02) fully documented with examples

## Task Commits

Each task was committed atomically:

1. **Task 1: Add folders, generate, and totp commands** - `0be99cb` (feat)
2. **Task 2: Update help text with all new commands** - `0acde1e` (feat)

## Files Created/Modified
- `bin/vault` - Added cmd_folders, cmd_generate, cmd_totp functions; wired into case statement; reorganized help text into 6 sections (+71 lines)

## Decisions Made
- TOTP remaining seconds use python3 `time.time()` with standard 30-second period calculation
- Password generation delegates entirely to `bw generate` with charset flags rather than implementing custom generation
- Help text organized into STATUS/LOOKUP/ITEM MANAGEMENT/UTILITIES/EXAMPLES/NOTE sections matching pattern from Plex (5 sections) and Jellyfin (6 sections) CLIs

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Vault CLI fully expanded with all 6 new commands (create, edit, delete, folders, generate, totp)
- Phase 13 complete - all BW requirements (BW-01 through BW-06) satisfied

## Self-Check: PASSED

- FOUND: bin/vault
- FOUND: 13-02-SUMMARY.md
- FOUND: 0be99cb (Task 1 commit)
- FOUND: 0acde1e (Task 2 commit)

---
*Phase: 13-vault*
*Completed: 2026-03-22*
