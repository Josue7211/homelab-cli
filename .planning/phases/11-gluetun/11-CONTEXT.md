# Phase 11: Gluetun - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 6 new commands to the Gluetun CLI for VPN provider info (provider), server list browsing (servers), server switching (switch), DNS configuration display (dns), forwarded port listing (ports), and connectivity leak testing (leak-test).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- No authentication: Gluetun REST API is unauthenticated (container-local access only)
- `gluetun_get()` and `gluetun_put()` already exist — no new helpers needed
- All endpoints under `/v1/` prefix
- `gluetun_put()` used for switch (changing server selection requires PUT with JSON body)
- Table formatting and column widths at Claude's discretion
- Server list may be large — default to showing first 20, accept optional `--filter` or count argument
- Leak test: check public IP via Gluetun's IP endpoint and compare to expected VPN exit IPs

### New commands
- **D-01:** `gluetun provider` — GET `/v1/vpn/settings` — show active VPN provider name, server region/country/city, protocol (openvpn/wireguard), and connection settings
- **D-02:** `gluetun servers [filter]` — GET `/v1/servers` — list available servers; optional filter by country/region substring; show hostname, country, region, city, protocol support
- **D-03:** `gluetun switch <country> [city]` — PUT `/v1/vpn/settings` with JSON `{"vpn":{"server_countries":["..."],"server_cities":["..."]}}` — switch VPN server by country/city filter; waits for reconnect status
- **D-04:** `gluetun dns` — GET `/v1/dns/settings` — show DNS-over-HTTPS configuration (provider, filtering, block lists enabled)
- **D-05:** `gluetun ports` — GET `/v1/portforwarding` — list all forwarded ports with port number and protocol; shows "none" if port forwarding not enabled
- **D-06:** `gluetun leak-test` — GET `/v1/publicip/ip` and compare against known VPN providers' IP ranges via DNS reverse lookup — show public IP, hostname, whether it matches expected VPN exit; warn if public IP resolves to ISP

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (GLU-01 through GLU-06).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/gluetun` — 202 lines, 7 commands: status, ip, port, start, stop, restart + help
- `gluetun_get()` — unauthenticated GET: `curl -sf "${GLUETUN_URL}/v1/${endpoint}"`
- `gluetun_put()` — unauthenticated PUT: `curl -sf -X PUT -H "Content-Type: application/json" --data "${body}" "${GLUETUN_URL}/v1/${endpoint}"`
- `lib/common.sh` — color helpers, human_size

### Established Patterns
- No auth; GLUETUN_URL from config (typically http://localhost:8000 or container IP)
- Python3 inline for JSON parsing
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/gluetun main() case statement
- Help text updated with PROVIDER, SERVERS, and DIAGNOSTICS sections
- Gluetun API: /v1/vpn/settings (GET+PUT), /v1/servers, /v1/dns/settings, /v1/portforwarding, /v1/publicip/ip

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 11-gluetun*
*Context gathered: 2026-03-22*
