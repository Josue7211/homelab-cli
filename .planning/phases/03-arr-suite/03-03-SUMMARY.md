---
phase: 03-arr-suite
plan: 03
subsystem: cli
tags: [bash, arr, sonarr, radarr, lidarr, prowlarr, blocklist, backup, logs, restart, maintenance]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: common.sh helpers (info, ok, warn, die, confirm_action)
  - phase: 03-arr-suite plan 01
    provides: arr_api pattern, Library Management section, app registry
  - phase: 03-arr-suite plan 02
    provides: Configuration Listing section, indexers pattern
provides:
  - cmd_blocklist listing blocklisted items with ID/title/date/reason
  - cmd_blocklist_clear bulk-deleting blocklist with confirmation prompt
  - cmd_backup triggering backup via POST /command
  - cmd_logs viewing application logs with configurable count and color-coded levels
  - cmd_restart restarting application via POST /system/restart
  - MAINTENANCE help section documenting all 5 maintenance commands
affects: [03-arr-suite]

# Tech tracking
tech-stack:
  added: []
  patterns: [maintenance-command-pattern, confirm-before-destructive, color-coded-log-levels]

key-files:
  created: []
  modified: [bin/arr]

key-decisions:
  - Blocklist commands limited to sonarr/radarr/lidarr (prowlarr/bazarr have different or no blocklist API)
  - Backup/logs/restart support sonarr/radarr/lidarr/prowlarr (bazarr has different API patterns)
  - Log count defaults to 25 lines, configurable via second argument

metrics:
  duration: 8min
  completed: "2026-03-22T08:13:37Z"
  tasks_completed: 2
  tasks_total: 2
  files_modified: 1
---

# Phase 03 Plan 03: ARR Maintenance Commands Summary

Five maintenance commands (blocklist, blocklist-clear, backup, logs, restart) added to the ARR CLI with confirm-before-destructive pattern and color-coded log output.

## What Was Done

### Task 1: cmd_blocklist and cmd_blocklist_clear (0e9942b)

Added two blocklist management functions:

- **cmd_blocklist()**: Fetches `/blocklist?page=1&pageSize=50&sortKey=date&sortDirection=descending` and displays a formatted table with ID, Title, Date, and Reason columns. Guards to sonarr/radarr/lidarr only.
- **cmd_blocklist_clear()**: Fetches all blocklist IDs (up to 1000), counts them, requires `confirm_action` before proceeding, then sends `DELETE /blocklist/bulk` with `{"ids": [...]}` payload. Handles empty blocklist gracefully.
- Wired both into main() case statement (`blocklist|bl`, `blocklist-clear|bl-clear`) and app-shortcut fallback.

### Task 2: cmd_backup, cmd_logs, cmd_restart, and help text (5914c53)

Added three maintenance operation functions:

- **cmd_backup()**: Sends `POST /command` with `{"name":"Backup"}` payload to trigger a backup. Guards to sonarr/radarr/lidarr/prowlarr.
- **cmd_logs()**: Fetches `/log?page=1&pageSize=${count}&sortKey=time&sortDirection=descending` with configurable count (default 25). Python formatting block color-codes error (red) and warn (yellow) levels, showing time, level, logger, and message.
- **cmd_restart()**: Sends `POST /system/restart` with empty body to restart the application. Guards to sonarr/radarr/lidarr/prowlarr.
- Wired all three into main() case statement and app-shortcut fallback.
- Added **MAINTENANCE** section to `cmd_help()` documenting all 5 maintenance commands.
- Added 5 maintenance examples to the EXAMPLES section.

## Deviations from Plan

None - plan executed exactly as written. Task 1 code was found as uncommitted changes from a previous session and was verified and committed.

## Decisions Made

1. **Blocklist limited to media apps**: sonarr/radarr/lidarr only because prowlarr and bazarr have different or no blocklist API endpoints.
2. **Backup/logs/restart include prowlarr**: These three operations support sonarr/radarr/lidarr/prowlarr since prowlarr shares the same API patterns for /command, /log, and /system/restart.
3. **Log count defaults to 25**: Reasonable default for quick inspection, overridable via second argument.

## Known Stubs

None - all commands are fully wired to their respective API endpoints.

## Self-Check: PASSED

All files exist, all commits verified, all functions present, help text updated.
