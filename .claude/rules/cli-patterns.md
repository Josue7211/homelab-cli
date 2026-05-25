# CLI Patterns

- All destructive operations MUST use `confirm_action` prompt before executing.
- Container ops go through Portainer API -- never Docker CLI for create/start/stop/recreate.
- Use `resolve_*_id` helpers for name-to-ID resolution.
- Inline `python3` for JSON parsing -- no jq dependency.
- Every command must have help text comprehensive enough for AI agent discovery.
- Think about: are all API features exposed? Could an AI agent accomplish any task without the web UI?
