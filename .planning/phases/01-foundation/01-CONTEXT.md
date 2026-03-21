# Phase 1: Foundation - Context

**Gathered:** 2026-03-21
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase delivers shared library helpers (confirm_action, api_patch) that all subsequent phases depend on, plus OpenCLI registration for AI agent discovery of all 14 CLIs.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase.

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- `lib/common.sh` — shared helpers: api_get, api_post, api_put, api_delete, get_secret, human_size, format_table, json_pp
- All 14 CLI scripts in `bin/` sourcing common.sh

### Established Patterns
- API helpers use curl with `-sf` flags and `X-Api-Key` header
- Output uses color helpers (info, ok, warn, err, die)
- Python3 inline for JSON parsing
- Config loaded from `~/.config/homelab-cli/config`

### Integration Points
- `confirm_action` will be called by all destructive commands in phases 2-15
- `api_patch` follows existing api_get/post/put/delete pattern
- OpenCLI registration at `~/.opencli/external-clis.yaml`

</code_context>

<specifics>
## Specific Ideas

- confirm_action should prompt "Are you sure? (y/N)" and default to No
- api_patch follows exact same pattern as api_put but with PATCH method
- OpenCLI registration uses YAML format with name, binary, description, tags

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>
