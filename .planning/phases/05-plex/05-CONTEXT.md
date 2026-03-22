# Phase 5: Plex - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 8 new commands to the Plex CLI for playlist/collection browsing, stream management, and server maintenance. All commands use the Plex Media Server API or Tautulli API as appropriate.

</domain>

<decisions>
## Implementation Decisions

### API helper
- **D-01:** Extend `plex_api()` to accept an optional method parameter: `plex_api <path> [method]`. Default is GET for backward compatibility. POST/PUT/DELETE needed for kill, optimize, and empty-trash.

### Playlist and collection browsing
- **D-02:** `plex playlists` uses GET `/playlists` — shows title, type, item count, duration, smart status.
- **D-03:** `plex collections [library_id]` uses GET `/library/sections/{id}/collections` — shows title, item count, sort title. If no library_id given, iterate all libraries.

### User management
- **D-04:** `plex shared` uses Plex API GET `/friends` (or Tautulli `get_users_table` for richer data). Shows username, email, shared libraries, last seen.

### Stream management
- **D-05:** `plex kill <session_id>` terminates a stream. Uses GET `/status/sessions/{sessionId}/stop` (Plex convention — uses GET for stop action, not POST). Requires `confirm_action` since it interrupts another user's stream. Session ID comes from `plex streams` output.
- **D-06:** `plex transcode` shows bandwidth and transcode details for active streams. Uses same session data as `plex streams` but focuses on transcode decision, video/audio codec, bandwidth, container format.

### Server maintenance
- **D-07:** `plex optimize` triggers database optimization via PUT `/library/optimize?async=1`. No confirmation needed (non-destructive).
- **D-08:** `plex empty-trash [library_id]` empties trash for a specific library or all libraries via PUT `/library/sections/{id}/emptyTrash`. Requires `confirm_action` (irreversible data deletion).
- **D-09:** `plex settings` shows server preferences via GET `/:\/prefs` — displays key settings like friendly name, library update interval, transcoder quality, remote access status.

### Claude's Discretion
- Exact column layout and formatting for each table
- Which Plex settings are most useful to display (subset of /prefs)
- Tautulli fallback behavior for shared users

</decisions>

<specifics>
## Specific Ideas

- Plex API quirk: some "action" endpoints use GET instead of POST (like session stop)
- Plex API requires X-Plex-Token header for all requests
- Collections endpoint requires the library section ID — can't list all collections without iterating libraries
- Server preferences endpoint uses `/:\/prefs` path (note the colon prefix)

</specifics>

<canonical_refs>
## Canonical References

No external specs — requirements are fully captured in decisions above and REQUIREMENTS.md (PLEX-01 through PLEX-08).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/plex` — 8 existing commands: status, streams, libraries, recent, history, users, scan, search
- `plex_api()` — GET-only API wrapper with X-Plex-Token auth
- `tautulli_api()` — command-based wrapper for Tautulli API
- `tautulli_available()` — connectivity check for Tautulli
- `lib/common.sh` — confirm_action, color helpers

### Established Patterns
- X-Plex-Token auth header on all requests
- JSON response via `Accept: application/json` header
- Python3 inline for JSON parsing and table formatting
- Tautulli used for richer data (history, users) when available
- `MediaContainer` wrapper in all Plex API responses

### Integration Points
- All new commands added to bin/plex main() case statement
- Help text updated with new sections (PLAYLISTS, MANAGEMENT)
- Plex API: /playlists, /library/sections/{id}/collections, /friends, /status/sessions, /library/optimize, /:\/prefs

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 05-plex*
*Context gathered: 2026-03-22*
