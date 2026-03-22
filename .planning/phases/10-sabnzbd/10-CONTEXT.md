# Phase 10: SABnzbd - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 8 new commands to the SABnzbd CLI for queue item inspection (info), queue item management (delete, pause-item, resume-item, priority), category listing (categories), speed limit management (limit), and server status (servers).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- Mode-based API: all calls follow `?apikey=KEY&mode=MODE&output=json` URL pattern — no separate helper needed, `sab_api()` already encodes this
- `confirm_action` required for destructive operations (delete)
- Item identification: commands accepting a queue item use NZO ID (the internal SABnzbd identifier shown in queue output)
- Table formatting and column widths at Claude's discretion
- Priority values: -100=stop, -1=low, 0=normal, 1=high, 2=force
- Speed limit: accepts value in KB/s (0=unlimited, also accepts percentage string like "50%")

### New commands
- **D-01:** `sab info <nzo_id>` — mode=queue, filter by nzo_id — show detailed item info (filename, size, progress, eta, category, priority, scripts)
- **D-02:** `sab delete <nzo_id>` — mode=queue with `name=delete&value=<nzo_id>` and `confirm_action` — remove item from queue; option `--del-files` to also delete downloaded files
- **D-03:** `sab pause-item <nzo_id>` — mode=queue with `name=pause&value=<nzo_id>` — pause a specific queue item
- **D-04:** `sab resume-item <nzo_id>` — mode=queue with `name=resume&value=<nzo_id>` — resume a paused queue item
- **D-05:** `sab priority <nzo_id> <level>` — mode=queue with `name=priority&value=<nzo_id>&value2=<level>` — set priority (stop/low/normal/high/force or numeric)
- **D-06:** `sab categories` — mode=get_cats — list all configured download categories
- **D-07:** `sab limit [speed]` — mode=queue (GET) to show current limit / mode=config with `name=speedlimit&value=<speed>` (POST) to set — show or set global speed limit in KB/s
- **D-08:** `sab servers` — mode=get_config, section=servers — list configured news servers with host, port, enabled state, connections, priority

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (SAB-01 through SAB-08).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/sab` — 251 lines, 8 commands: status, speed, queue, history, add, pause, resume + help
- `sab_api()` — mode-based: builds URL as `${SAB_URL}/api?apikey=${SAB_KEY}&mode=${mode}&output=json` and appends extra params
- `lib/common.sh` — confirm_action, color helpers, human_size

### Established Patterns
- API key in config as `SAB_KEY`; all requests append `&apikey=${SAB_KEY}&output=json`
- `sab_api mode [extra_params]` pattern where extra_params are URL-encoded key=value pairs
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/sab main() case statement
- Help text updated with QUEUE MANAGEMENT, CONFIGURATION sections
- SABnzbd API modes: queue (with name/value sub-actions), get_cats, get_config, config (for settings changes)

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 10-sabnzbd*
*Context gathered: 2026-03-22*
