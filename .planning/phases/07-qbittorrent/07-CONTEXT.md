# Phase 7: qBittorrent - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 10 new commands to the qBittorrent CLI for torrent inspection (info, files, trackers, peers), torrent management (priority, move, set-category), speed limits (limit-dl, limit-ul), and category listing — plus a `qbt_post()` helper for all write operations.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- Cookie-based auth: `qbt_login()` must be called before any request; session cookie stored in a temp file and passed via `--cookie-jar` / `--cookie`
- All API endpoints under `/api/v2/` (e.g., `/api/v2/torrents/info`, `/api/v2/torrents/files`)
- `qbt_post()` helper mirrors `qbt_get()` but sends POST with `--data` — needed for all write operations
- Hash resolution: commands that take a torrent name must resolve to hash via `torrents/info?filter=all`
- `confirm_action` required for destructive operations (delete already uses it; priority/move do not need it)
- Table formatting and column widths at Claude's discretion
- Which tracker/peer fields to surface (tier, url, status, seeds for trackers; ip, port, progress for peers)

### New commands
- **D-01:** `qbt info <hash|name>` — GET `torrents/properties` — detailed torrent metadata (size, ratio, seeds, peers, paths, dates)
- **D-02:** `qbt files <hash|name>` — GET `torrents/files` — list files with size, progress, priority
- **D-03:** `qbt priority <hash|name> <file-index> <prio>` — POST `torrents/filePrio` — set per-file download priority (0=skip,1=normal,6=high,7=max)
- **D-04:** `qbt limit-dl [speed]` — GET `transfer/downloadLimit` / POST `transfer/setDownloadLimit` — show or set global download limit (bytes/s, 0=unlimited)
- **D-05:** `qbt limit-ul [speed]` — GET `transfer/uploadLimit` / POST `transfer/setUploadLimit` — show or set global upload limit (bytes/s, 0=unlimited)
- **D-06:** `qbt categories` — GET `torrents/categories` — list all categories with save paths
- **D-07:** `qbt set-category <hash|name> <category>` — POST `torrents/setCategory` — assign torrent to category
- **D-08:** `qbt move <hash|name> <path>` — POST `torrents/setLocation` — change torrent save location
- **D-09:** `qbt trackers <hash|name>` — GET `torrents/trackers` — list trackers with tier, URL, status, seed/peer counts
- **D-10:** `qbt peers <hash|name>` — GET `sync/torrentPeers` — list connected peers with IP, port, client, progress, speeds

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (QBT-01 through QBT-10).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/qbt` — 310 lines, 8 commands: status, speed, list, add, pause, resume, delete + help
- `qbt_get()` — GET-only helper with cookie auth via `qbt_login()` (session cookie in temp file)
- `lib/common.sh` — confirm_action, color helpers, human_size

### Established Patterns
- Cookie auth: login to `/api/v2/auth/login` on first call, reuse session cookie
- `qbt_get()` pattern: `curl -sf --cookie "$QBT_COOKIE_JAR" "${QBT_URL}/api/v2/${endpoint}"`
- `qbt_post()` to add: same as `qbt_get()` but `curl -sf -X POST --cookie "$QBT_COOKIE_JAR" --data "${data}" "${QBT_URL}/api/v2/${endpoint}"`
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/qbt main() case statement
- `qbt_post()` added alongside existing `qbt_get()` at top of script
- Help text updated with INSPECTION, MANAGEMENT, and LIMITS sections
- qBittorrent API: /api/v2/torrents/{properties,files,filePrio,setCategory,setLocation,categories}, /api/v2/transfer/{downloadLimit,uploadLimit,setDownloadLimit,setUploadLimit}, /api/v2/sync/torrentPeers

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 07-qbittorrent*
*Context gathered: 2026-03-22*
