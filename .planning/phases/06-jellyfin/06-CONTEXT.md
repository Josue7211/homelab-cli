# Phase 6: Jellyfin - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 8 new commands to the Jellyfin CLI for user management (list, create, delete), scheduled task management (list, run), plugin listing, activity log, and server info display.

</domain>

<decisions>
## Implementation Decisions

### API helper
- **D-01:** `jellyfin_api()` already supports GET/POST/DELETE with MediaBrowser Token auth — no refactoring needed.

### User management
- **D-02:** `jellyfin users` uses GET `/Users` — shows name, ID, admin status, last activity, has password.
- **D-03:** `jellyfin user-add <name> <password>` uses POST `/Users/New` with JSON body `{"Name": "...", "Password": "..."}`.
- **D-04:** `jellyfin user-rm <name>` resolves name to ID via GET `/Users`, then DELETE `/Users/{id}` with `confirm_action`.

### Task management
- **D-05:** `jellyfin tasks` uses GET `/ScheduledTasks` — shows name, state, last execution, trigger info.
- **D-06:** `jellyfin run-task <id>` uses POST `/ScheduledTasks/Running/{id}` — triggers task immediately.

### Server info
- **D-07:** `jellyfin plugins` uses GET `/Plugins` — shows name, version, status, description.
- **D-08:** `jellyfin activity [count]` uses GET `/System/ActivityLog/Entries?limit={count}` — shows date, user, type, text. Default count 25.
- **D-09:** `jellyfin info` uses GET `/System/Info` — shows server name, version, OS, architecture, startup time, web path, local address.

### Claude's Discretion
- Table formatting and column widths
- Which task trigger info to show (daily, weekly, interval)
- Activity log severity coloring

</decisions>

<specifics>
## Specific Ideas

- Jellyfin uses `Authorization: MediaBrowser Token="<key>"` auth (already implemented)
- User deletion requires resolving username to ID first (Jellyfin API uses ID-based paths)
- Scheduled tasks API returns detailed trigger and execution history

</specifics>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (JF-01 through JF-08).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/jellyfin` — 9 existing commands: status, streams, libraries, recent, search, scan, devices, logs
- `jellyfin_api()` — multi-method (GET/POST/DELETE) with MediaBrowser Token auth
- `lib/common.sh` — confirm_action, color helpers

### Established Patterns
- MediaBrowser Token auth header
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/jellyfin main() case statement
- Help text updated with USER MANAGEMENT, TASKS, and SERVER sections
- Jellyfin API: /Users, /Users/New, /ScheduledTasks, /Plugins, /System/ActivityLog/Entries, /System/Info

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 06-jellyfin*
*Context gathered: 2026-03-22*
