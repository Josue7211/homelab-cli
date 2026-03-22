# Phase 8: AdGuard - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 8 new commands to the AdGuard Home CLI for DHCP lease management (dhcp, dhcp-add), DNS rewrite management (rewrites, rewrite-add, rewrite-rm), block/allow list management (unblock/unallow), and client management (clients, client).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- Basic auth: `ag_api()` already handles GET/POST with `Authorization: Basic base64(user:pass)`
- No additional auth helper needed — `ag_api()` is multi-method and covers all operations
- `confirm_action` required for destructive operations (rewrite-rm, unblock/unallow)
- Table formatting and column widths at Claude's discretion
- DHCP lease display: hostname, MAC, IP, expiry
- Rewrite display: domain, answer (IP or CNAME)
- Client display: name, IDs (IPs/MACs), filtering enabled, blocked services

### New commands
- **D-01:** `adguard dhcp` — GET `/control/dhcp/status` — show DHCP server status, active leases (IP, MAC, hostname, expiry), static leases
- **D-02:** `adguard dhcp-add <ip> <mac> <hostname>` — POST `/control/dhcp/add_static_lease` — add a static DHCP lease with JSON body `{"ip":"...","mac":"...","hostname":"..."}`
- **D-03:** `adguard rewrites` — GET `/control/rewrite/list` — list all DNS rewrites (domain → IP or CNAME)
- **D-04:** `adguard rewrite-add <domain> <answer>` — POST `/control/rewrite/add` — add DNS rewrite with JSON `{"domain":"...","answer":"..."}`
- **D-05:** `adguard rewrite-rm <domain>` — POST `/control/rewrite/delete` with `confirm_action` — remove DNS rewrite matching domain
- **D-06:** `adguard unblock <domain>` — GET blocked list, POST `/control/filtering/set_rules` with domain removed — remove a domain from custom block list; `confirm_action`
- **D-07:** `adguard unallow <domain>` — GET allowed list, POST with domain removed — remove a domain from custom allow list; `confirm_action`
- **D-08:** `adguard clients` — GET `/control/clients` — list persistent clients with name, IDs, tags, filtering status
- **D-09:** `adguard client <name>` — GET `/control/clients`, filter by name — show detailed config for a single client (blocked services, upstreams, safe search)

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (AG-01 through AG-08).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/adguard` — 465 lines, 16 commands including status, stats, enable/disable filtering, block/allow, logs, querylog
- `ag_api()` — multi-method (GET/POST) with basic auth (`Authorization: Basic`)
- `lib/common.sh` — confirm_action, color helpers

### Established Patterns
- Basic auth encoded as `base64(AG_USER:AG_PASS)` from config
- `ag_api GET /control/endpoint` and `ag_api POST /control/endpoint '{"json":"body"}'`
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/adguard main() case statement
- Help text updated with DHCP, REWRITES, and CLIENTS sections
- AdGuard API: /control/dhcp/status, /control/dhcp/add_static_lease, /control/rewrite/list, /control/rewrite/add, /control/rewrite/delete, /control/filtering/set_rules, /control/clients

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 08-adguard*
*Context gathered: 2026-03-22*
