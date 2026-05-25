# Extend, Don't Rewrite

- Always extend existing bash CLIs -- never rewrite from scratch.
- Don't rebuild CLIs for services that have official CLIs (supabase, wrangler, cloudflared, bw, obsidian).
- Add missing commands to existing scripts, follow the patterns already in each CLI.
- Each CLI sources `lib/common.sh` at top -- use its helpers (api_get/post/put/delete, get_secret, format_table).
- All secrets retrieved via `bw` CLI at runtime -- never hardcoded.
