# Phase 2: Portainer - Context

**Gathered:** 2026-03-21
**Status:** Ready for planning

<domain>
## Phase Boundary

Full stack, container, and resource management via Portainer API across both instances (services + plex). Every operation currently requiring the Portainer web UI becomes a CLI command.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase. Follow existing patterns in bin/portainer exactly:
- `pt_api_get`/`pt_api_post`/`pt_api_put`/`pt_api_delete` wrappers
- `resolve_stack_id` for name-to-ID resolution
- Python3 inline for JSON parsing and display
- Instance-based routing (services/plex)
- Token caching per-session via `get_token`
- All destructive operations must use `confirm_action` from common.sh

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/portainer` — 9 existing commands: status, stacks, stack, compose, env, containers, logs, restart, redeploy
- `lib/common.sh` — confirm_action (new), api_patch (new), api_get/post/put/delete
- `resolve_stack_id()` — name-to-ID resolution for stacks
- Container ID resolution logic duplicated in cmd_logs and cmd_restart (needs DRY refactor → PT-20)

### Established Patterns
- Instance routing via associative arrays: URLS[], VAULT_ENTRIES[], ENDPOINT_IDS[], CURL_FLAGS[]
- Default instance: $DEFAULT_INSTANCE (services)
- pt_api() wraps curl with X-API-Key auth header
- Python3 inline scripts for JSON parsing with color output

### Integration Points
- All new commands added to bin/portainer main() case statement
- Help text updated in cmd_help()
- Portainer API: /stacks, /endpoints/{eid}/docker/*, /stacks/{id}/*

</code_context>

<specifics>
## Specific Ideas

- Stack creation must support both --file and --inline (stdin) modes
- confirm_action used for: delete stack, volume-rm, prune
- resolve_container_id extracted as shared helper (DRY refactor)
- Container inspect should mask sensitive env vars (PASSWORD, SECRET, TOKEN, KEY)

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
