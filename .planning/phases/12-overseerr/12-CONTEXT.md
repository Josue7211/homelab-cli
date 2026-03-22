# Phase 12: Overseerr - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 5 new commands to the Overseerr CLI for bulk request approval (approve-all), user management (users), single request detail (request), connected service status (services), and notification agent listing (notifications).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- X-Api-Key auth: `overseerr_api()` already handles GET/POST/DELETE with `X-Api-Key` header
- All endpoints under `/api/v1/` prefix — already implemented in existing helper
- `confirm_action` required for approve-all (bulk operation)
- Pagination: Overseerr API returns paginated results; commands should handle `take`/`skip` or show first N with count
- Table formatting and column widths at Claude's discretion
- User display: name, email, role (admin/user), request count, permissions

### New commands
- **D-01:** `overseerr approve-all` — GET `/api/v1/request?filter=pending&take=100`, then POST `/api/v1/request/{id}/approve` for each — bulk approve all pending requests with `confirm_action`; shows count of approved items
- **D-02:** `overseerr users` — GET `/api/v1/user?take=50` — list all users with ID, display name, email, user type (plex/local), request count, permissions
- **D-03:** `overseerr request <id>` — GET `/api/v1/request/{id}` — show full detail for a single request: media title, type, requester, status, seasons (if TV), created date, modified date
- **D-04:** `overseerr services` — GET `/api/v1/service/radarr` and `/api/v1/service/sonarr` — list configured Radarr/Sonarr service integrations with name, URL, active/default status, profile
- **D-05:** `overseerr notifications` — GET `/api/v1/settings/notifications/` — list notification agents (email, Discord, Slack, Telegram, Pushover, webhook) with enabled state and configuration summary

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (OVR-01 through OVR-05).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/overseerr` — 371 lines, 9 commands: status, requests, search, request, approve, decline, delete, media + help
- `overseerr_api()` — multi-method (GET/POST/DELETE) with `X-Api-Key: ${OVERSEERR_KEY}` header
- `lib/common.sh` — confirm_action, color helpers

### Established Patterns
- API key in config as `OVERSEERR_KEY`; header `X-Api-Key: ${OVERSEERR_KEY}`
- `overseerr_api GET /api/v1/endpoint` and `overseerr_api POST /api/v1/endpoint '{"json":"body"}'`
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/overseerr main() case statement
- Help text updated with USER MANAGEMENT and CONFIGURATION sections
- Overseerr API: /api/v1/request (with filter/take params), /api/v1/request/{id}/approve, /api/v1/user, /api/v1/service/{radarr,sonarr}, /api/v1/settings/notifications/

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 12-overseerr*
*Context gathered: 2026-03-22*
