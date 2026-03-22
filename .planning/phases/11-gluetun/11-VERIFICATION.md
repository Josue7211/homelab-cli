---
phase: 11-gluetun
verified: 2026-03-22T00:00:00Z
status: passed
score: 6/6 must-haves verified
re_verification: false
---

# Phase 11: Gluetun Verification Report

**Phase Goal:** Users can inspect VPN status, switch servers, and verify connection security from the command line
**Verified:** 2026-03-22
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| #  | Truth                                                        | Status     | Evidence                                                              |
|----|--------------------------------------------------------------|------------|-----------------------------------------------------------------------|
| 1  | User can view current VPN provider info, protocol, and server region | VERIFIED | `cmd_provider()` at line 150 calls `gluetun_get "/v1/vpn/settings"`, parses and displays Provider, Protocol, Countries, Regions, Cities, Hostnames |
| 2  | User can list available servers/regions with optional filtering | VERIFIED | `cmd_servers()` at line 175 calls `gluetun_get "/v1/servers"`, FILTER env var passed to python3, limits to 20 by default, shows all when filter provided |
| 3  | User can view DNS-over-HTTPS configuration                   | VERIFIED | `cmd_dns()` at line 234 calls `gluetun_get "/v1/dns/settings"`, displays DoH providers, DNS addresses, keep_nameserver, block settings |
| 4  | User can view port forwarding status                         | VERIFIED | `cmd_ports()` at line 267 tries `/v1/portforwarding` first, falls back to `/v1/openvpn/portforwarded`; displays ports or "not active" |
| 5  | User can switch VPN server by country and optional city      | VERIFIED | `cmd_switch()` at line 315 validates country arg, builds JSON via python3 os.environ, calls `gluetun_put "/v1/vpn/settings"`, waits 3s, shows new status and IP |
| 6  | User can run a DNS leak test to verify VPN security          | VERIFIED | `cmd_leak_test()` at line 374 calls `gluetun_get "/v1/publicip/ip"`, performs reverse DNS via host/nslookup/dig chain, checks against 13 VPN provider patterns, outputs PASS or WARNING verdict |

**Score:** 6/6 truths verified

### Required Artifacts

| Artifact     | Expected                                         | Status   | Details                                                                    |
|--------------|--------------------------------------------------|----------|----------------------------------------------------------------------------|
| `bin/gluetun` | cmd_provider, cmd_servers, cmd_dns, cmd_ports (plan 01) | VERIFIED | All 4 functions defined at lines 150, 175, 234, 267; 4 case entries at lines 494-497 |
| `bin/gluetun` | cmd_switch, cmd_leak_test + updated help text (plan 02) | VERIFIED | Both functions defined at lines 315, 374; case entries at lines 498-499; help text has PROVIDER, CONTROL, DIAGNOSTICS sections |

**Artifact substantiveness:** `bin/gluetun` is 509 lines. All 6 new functions contain real API calls, python3 JSON parsing, and formatted output. No stubs or placeholder bodies detected. No TODO/FIXME/placeholder comments found.

### Key Link Verification

| From         | To                                           | Via                            | Status   | Details                                          |
|--------------|----------------------------------------------|--------------------------------|----------|--------------------------------------------------|
| `bin/gluetun` | GET /v1/vpn/settings                        | `gluetun_get` at line 153      | VERIFIED | Called inside `cmd_provider`, result piped to python3 |
| `bin/gluetun` | GET /v1/servers                             | `gluetun_get` at line 179      | VERIFIED | Called inside `cmd_servers`, result piped to python3 |
| `bin/gluetun` | GET /v1/dns/settings                        | `gluetun_get` at line 237      | VERIFIED | Called inside `cmd_dns`, result piped to python3 |
| `bin/gluetun` | GET /v1/portforwarding (+ legacy fallback)  | `gluetun_get` at lines 271, 299 | VERIFIED | Dual-endpoint fallback: new endpoint tried first, legacy `/v1/openvpn/portforwarded` as fallback |
| `bin/gluetun` | PUT /v1/vpn/settings for server switching   | `gluetun_put` at line 335      | VERIFIED | Pattern `gluetun_put "/v1/vpn/settings" "$payload"` confirmed; payload built with `server_countries` array |
| `bin/gluetun` | GET /v1/publicip/ip for leak test           | `gluetun_get` at line 379      | VERIFIED | Called inside `cmd_leak_test`; result parsed for public_ip, then used in reverse DNS chain |

### Requirements Coverage

| Requirement | Source Plan | Description                                            | Status    | Evidence                                                    |
|-------------|-------------|--------------------------------------------------------|-----------|-------------------------------------------------------------|
| GLU-01      | 11-01       | Show VPN provider info (`gluetun provider`)           | SATISFIED | `cmd_provider()` exists, wired to `provider)` case, calls `/v1/vpn/settings` |
| GLU-02      | 11-01       | List available servers/regions (`gluetun servers`)    | SATISFIED | `cmd_servers()` exists, wired to `servers)` case, calls `/v1/servers`, supports filter arg |
| GLU-03      | 11-02       | Switch server/region (`gluetun switch <server>`)      | SATISFIED | `cmd_switch()` exists, wired to `switch)` case with `"$@"`, PUTs to `/v1/vpn/settings` with `server_countries` |
| GLU-04      | 11-01       | Show DNS config (`gluetun dns`)                       | SATISFIED | `cmd_dns()` exists, wired to `dns)` case, calls `/v1/dns/settings`, shows DoH and block settings |
| GLU-05      | 11-01       | Show port forward status and history (`gluetun ports`) | SATISFIED | `cmd_ports()` exists, wired to `ports)` case, dual-endpoint fallback implemented |
| GLU-06      | 11-02       | Check for DNS leaks (`gluetun leak-test`)             | SATISFIED | `cmd_leak_test()` exists, wired to `leak-test)` case, reverse DNS via host/nslookup/dig, verdict output |

All 6 requirement IDs from plan frontmatter are accounted for. No orphaned requirements found — REQUIREMENTS.md maps exactly GLU-01 through GLU-06 to Phase 11, all satisfied.

### Anti-Patterns Found

None. Scan results:
- No TODO/FIXME/XXX/HACK/placeholder comments
- No empty function bodies
- No stub return values (return null, return {}, etc.)
- All 6 functions make real API calls and process responses
- `bash -n bin/gluetun` passes (confirmed)

### Human Verification Required

#### 1. VPN server switch live behavior

**Test:** Run `gluetun switch Netherlands` against a live Gluetun instance
**Expected:** VPN reconnects to a Dutch server within ~3 seconds, new public IP displayed with Netherlands location, "Server switched to Netherlands" confirmation shown
**Why human:** Requires live Gluetun container; can't verify reconnect timing or IP geo response programmatically

#### 2. DNS leak test verdict accuracy

**Test:** Run `gluetun leak-test` when connected to a known VPN provider
**Expected:** Reverse DNS hostname matches a known VPN pattern, output shows "PASS - IP reverse DNS matches VPN provider"
**Why human:** Depends on live public IP and external DNS resolution; VPN provider pattern list correctness is subjective

#### 3. Server filter output

**Test:** Run `gluetun servers us` against a live Gluetun instance
**Expected:** Filtered server list showing only US servers, all 4 columns (Hostname, Country, Region, City) populated
**Why human:** Depends on actual Gluetun server list API response format

### Commit Verification

All 3 commits documented in SUMMARYs confirmed present in git log:
- `fb4c4c3` — feat(11-01): add cmd_provider and cmd_servers commands
- `99fbc53` — feat(11-01): add cmd_dns and cmd_ports commands with updated help text
- `5909509` — feat(11-02): add switch and leak-test commands to gluetun CLI

### Summary

Phase 11 goal is fully achieved. All 6 new commands (`provider`, `servers`, `dns`, `ports`, `switch`, `leak-test`) are implemented with substantive bodies, wired into the main() case statement, and connected to the correct Gluetun API endpoints. The binary passes bash syntax check. Help text is organized into STATUS/PROVIDER/CONTROL/DIAGNOSTICS sections covering all 13 gluetun commands. All 6 requirement IDs (GLU-01 through GLU-06) are satisfied with no orphans. No stubs or anti-patterns detected.

---

_Verified: 2026-03-22_
_Verifier: Claude (gsd-verifier)_
