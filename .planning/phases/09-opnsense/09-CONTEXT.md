# Phase 9: OPNsense - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 8 new commands to the OPNsense CLI for firewall rule management (rule-add, rule-rm, rule-toggle), alias management (alias-add), DHCP lease addition (dhcp-add), VPN status (vpn), configuration apply (apply), and live traffic stats (traffic).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- Key:secret auth: `opn_get()` and `opn_post()` both use `Authorization: Basic base64(key:secret)`
- `opn_post()` already exists alongside `opn_get()` — no new helper needed
- `confirm_action` required for destructive operations (rule-rm)
- Rule changes require explicit `apply` call to take effect (OPNsense two-phase commit)
- Table formatting and column widths at Claude's discretion
- Rule display: sequence, description, action (pass/block/reject), interface, source, destination, enabled state
- Traffic display: interface, in/out rates (human-readable)

### New commands
- **D-01:** `opnsense rule-add <descr> <action> <interface> <src> <dst>` — POST `/api/firewall/filter/addRule` — add a firewall rule; remind user to run `apply`
- **D-02:** `opnsense rule-rm <uuid>` — POST `/api/firewall/filter/delRule/{uuid}` with `confirm_action` — delete a firewall rule; remind user to run `apply`
- **D-03:** `opnsense rule-toggle <uuid>` — POST `/api/firewall/filter/toggleRule/{uuid}` — enable or disable a firewall rule; remind user to run `apply`
- **D-04:** `opnsense alias-add <name> <type> <content>` — POST `/api/firewall/alias/addItem` — add a firewall alias (host, network, or port); type: host|network|port
- **D-05:** `opnsense dhcp-add <interface> <ip> <mac>` — POST `/api/dhcpv4/leases/addLease` — add a static DHCP lease on the specified interface
- **D-06:** `opnsense vpn` — GET `/api/openvpn/instances/search` and `/api/ipsec/sessions` — show OpenVPN and IPsec session status (client, IP, connected since, bytes)
- **D-07:** `opnsense apply` — POST `/api/firewall/filter/apply` — apply pending firewall rule changes; shows result status
- **D-08:** `opnsense traffic` — GET `/api/diagnostics/traffic/interface` — show live interface traffic rates (in/out bytes/s formatted with human_size)

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (OPN-01 through OPN-08).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/opnsense` — 422 lines, 14 commands: status, interfaces, routes, aliases, rules, dhcp, arp, logs, gateway, firmware, services, service, reboot, halt
- `opn_get()` — GET with key:secret basic auth
- `opn_post()` — POST with key:secret basic auth and JSON body
- `lib/common.sh` — confirm_action, color helpers, human_size

### Established Patterns
- API key:secret stored in config as `OPN_KEY` and `OPN_SECRET`; auth as `base64(OPN_KEY:OPN_SECRET)`
- `opn_get /api/module/controller/action` and `opn_post /api/module/controller/action '{"key":"val"}'`
- Python3 inline for JSON parsing
- Two-phase commit pattern: add/modify rules, then POST apply
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/opnsense main() case statement
- Help text updated with FIREWALL MANAGEMENT, ALIASES, and DIAGNOSTICS sections
- OPNsense API: /api/firewall/filter/{addRule,delRule,toggleRule,apply}, /api/firewall/alias/addItem, /api/dhcpv4/leases/addLease, /api/openvpn/instances/search, /api/ipsec/sessions, /api/diagnostics/traffic/interface

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 09-opnsense*
*Context gathered: 2026-03-22*
