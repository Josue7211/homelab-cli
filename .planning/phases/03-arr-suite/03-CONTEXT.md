# Phase 3: ARR Suite - Context

**Gathered:** 2026-03-21
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 14 new commands to the ARR CLI covering library CRUD (add, delete, download, rename), configuration listing (profiles, rootfolders, tags, tag-add, indexers), and maintenance operations (blocklist, blocklist-clear, backup, logs, restart). All commands work across Sonarr, Radarr, Lidarr, Prowlarr, and Bazarr via the existing unified API pattern.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase. Key constraints:
- Follow existing `arr_api_get/post/put/delete` patterns in bin/arr
- All commands take `<app>` as first arg (sonarr/radarr/lidarr/prowlarr/bazarr)
- Use `confirm_action` from lib/common.sh for destructive ops (delete, blocklist-clear)
- Bazarr has different API patterns — some commands may not apply (document gaps)
- Prowlarr doesn't have library items — skip add/delete/download/rename for Prowlarr
- API versions differ: Sonarr/Radarr use v3, Lidarr/Prowlarr use v1, Bazarr has no version prefix

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- bin/arr already has 11 commands: status, queue, queue-clear, activity, calendar, search, library, system, wanted, health, diskspace
- Unified API helpers: `arr_api_get`, `arr_api_post`, `arr_api_put`, `arr_api_delete`
- App registry pattern: `APP_URLS`, `APP_API_VERSIONS`, `APP_KEY_SOURCES` associative arrays
- `get_api_key()` with caching across config/bw/env sources
- `confirm_action` from lib/common.sh for destructive operations

### Established Patterns
- All commands follow: `cmd_<name>() { local app="$1"; ... arr_api_get "$app" "/endpoint" | python3 formatting }`
- Main case statement maps `<cmd>)` to `cmd_<name> "$app" "$@"`
- Python3 inline blocks for JSON parsing and table formatting
- `die` for fatal errors, `info`/`ok`/`warn` for status messages

### Integration Points
- Sonarr API: /api/v3/series, /api/v3/qualityprofile, /api/v3/rootfolder, /api/v3/tag, /api/v3/indexer, /api/v3/blocklist, /api/v3/system/backup, /api/v3/log, /api/v3/system/restart
- Radarr API: /api/v3/movie (same pattern as Sonarr but different entity names)
- Lidarr API: /api/v1/artist, same sub-endpoints
- Prowlarr API: /api/v1/indexer (main entity, no library items)
- Bazarr API: /api/series, /api/movies (no version prefix, different patterns)

</code_context>

<specifics>
## Specific Ideas

No specific requirements — infrastructure phase

</specifics>

<deferred>
## Deferred Ideas

None

</deferred>
