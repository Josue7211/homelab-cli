# Phase 13: Vault - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add 6 new commands to the Vault (Vaultwarden/Bitwarden) CLI for item creation (create), item editing (edit), item deletion (delete), folder listing (folders), password generation (generate), and TOTP code retrieval (totp).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- Uses `bw` CLI binary, not a REST API — all operations invoke `bw` subcommands
- Session management: `BW_SESSION` env var must be set; existing CLI handles unlock/session
- `confirm_action` required for delete (irreversible in Vaultwarden without admin recovery)
- Item creation uses `bw get template item` piped through modification then `bw create item`
- Edit uses `bw get item <id>` → modify JSON → `bw edit item <id>`
- JSON encoding for create/edit: use Python3 inline to build/modify JSON, then base64-encode for `bw create`
- Table formatting and column widths at Claude's discretion

### New commands
- **D-01:** `vault create <name> <username> <password> [--url URL] [--folder FOLDER]` — `bw get template item` → patch JSON fields → `bw encode` → `bw create item` — create a new login item; prints new item ID on success
- **D-02:** `vault edit <id|name> [--username U] [--password P] [--url URL] [--notes N]` — `bw get item <id>` → patch specified fields → `bw encode` → `bw edit item <id>` — update fields on an existing item
- **D-03:** `vault delete <id|name>` — `bw delete item <id>` with `confirm_action` — permanently delete a vault item; resolves name to ID if needed
- **D-04:** `vault folders` — `bw list folders` — list all folders with ID and name; shows "(no folder)" entry for unorganised items
- **D-05:** `vault generate [--length N] [--no-symbols] [--numbers-only]` — `bw generate` with flags — generate a password using Bitwarden's generator; default length 20 with symbols
- **D-06:** `vault totp <id|name>` — `bw get totp <id>` — retrieve the current TOTP code for an item that has an authenticator key configured; shows code and remaining seconds

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (BW-01 through BW-06).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/vault` — 174 lines, 8 commands: status, get, user, item, search, list, sync + help
- Session handling: checks `BW_SESSION` env var; existing `vault unlock` or env setup
- `lib/common.sh` — confirm_action, color helpers

### Established Patterns
- All operations: `bw <subcommand> [args] --session "${BW_SESSION}"` (session passed explicitly or via env)
- Name-to-ID resolution: `bw list items --search "<name>" --session ...` then pick first match or prompt
- Python3 inline for JSON manipulation (get template → patch → re-encode)
- `bw encode` for base64-encoding JSON before create/edit
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- All new commands added to bin/vault main() case statement
- Help text updated with ITEM MANAGEMENT and UTILITIES sections
- bw CLI commands used: get template item, create item, get item, edit item, delete item, list folders, generate, get totp

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 13-vault*
*Context gathered: 2026-03-22*
