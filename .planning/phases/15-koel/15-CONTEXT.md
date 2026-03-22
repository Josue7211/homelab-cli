# Phase 15: Koel - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 5 new API-backed commands to the Koel CLI for music library search (search), playlist listing (playlists), recently played tracks (recent), library statistics (stats), and album/artist browsing (albums, artists) — bridging the existing Docker-management CLI with Koel's REST API.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- Existing CLI is Docker/compose management focused — new commands require a new `koel_api()` helper
- Koel REST API uses Bearer token auth: `Authorization: Bearer <token>`
- Token obtained via POST `/api/me` with `email` and `password` credentials from config; token stored in `~/.cache/homelab-cli/koel-token` with TTL check (Koel tokens are long-lived)
- All API endpoints under `/api/` prefix
- Table formatting and column widths at Claude's discretion
- Search returns mixed results (songs, albums, artists) — display grouped by type

### New helper
- **D-00:** `koel_api()` — multi-method (GET/POST/DELETE) with `Authorization: Bearer ${KOEL_TOKEN}` header; auto-refreshes token if missing or expired by calling `koel_login()`

### New commands
- **D-01:** `koel search <query>` — GET `/api/search?q=<query>` — search songs, albums, and artists; display results grouped by type with title, album/artist, duration
- **D-02:** `koel playlists` — GET `/api/playlist` — list all playlists with ID, name, song count, and owner
- **D-03:** `koel recent` — GET `/api/interaction/recently-played` — show recently played tracks with title, artist, album, played-at timestamp; default 20 items
- **D-04:** `koel stats` — GET `/api/data` — show library statistics: total songs, albums, artists, total duration, total file size
- **D-05:** `koel albums [artist]` — GET `/api/album` (optionally filtered by artist name) — browse albums with title, artist, year, song count; optional artist name filter
- **D-06:** `koel artists` — GET `/api/artist` — list all artists with name, album count, song count

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (KOEL-01 through KOEL-05).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/koel` — 178 lines, 14 commands mostly Docker/compose: up, down, restart, logs, pull, exec, backup, restore, scan, etc.
- No existing API helper — `koel_api()` must be added fresh
- `lib/common.sh` — color helpers, human_size, confirm_action

### Established Patterns (from other CLIs)
- Bearer token auth pattern (similar to Jellyfin's MediaBrowser token pattern)
- Token caching: store in `~/.cache/homelab-cli/koel-token`, check age before reuse
- `koel_login()`: POST `/api/me` with `{"email":"...","password":"..."}`, extract `.token` from JSON response
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- `koel_api()` and `koel_login()` added at top of bin/koel alongside existing Docker helpers
- Credentials `KOEL_EMAIL` and `KOEL_PASS` (or `KOEL_TOKEN` if pre-configured) read from `~/.config/homelab-cli/config`
- New API commands added to main() case statement alongside existing Docker commands
- Help text updated with LIBRARY section for new commands
- Koel API: POST /api/me (auth), GET /api/search, GET /api/playlist, GET /api/interaction/recently-played, GET /api/data, GET /api/album, GET /api/artist

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 15-koel*
*Context gathered: 2026-03-22*
