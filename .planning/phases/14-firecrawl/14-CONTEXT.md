# Phase 14: Firecrawl - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Enhance 2 existing commands (scrape, crawl) with new flags and add 3 new commands to the Firecrawl CLI: batch URL scraping (batch), crawl job cancellation (cancel), and active job listing (jobs).

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion. Key constraints:
- No authentication: local Firecrawl instance is unauthenticated
- `fc_get()` and `fc_post()` already exist — no new helpers needed
- All endpoints under `/v1/` prefix — already implemented
- Crawl jobs are async: POST returns a job ID, status polled via GET `/v1/crawl/{id}`
- `confirm_action` required for cancel (terminates in-progress crawl)
- Output format: scrape returns markdown by default; batch returns array of results

### Enhanced existing commands
- **D-01:** `firecrawl scrape <url> [--wait N] [--headers 'K:V,...']` — add `--wait` (poll interval for JS-heavy pages, seconds) and `--headers` (custom request headers as comma-separated K:V pairs) to existing scrape command
- **D-02:** `firecrawl crawl <url> [--depth N] [--include PATTERN] [--exclude PATTERN]` — add `--depth` (max crawl depth, default 2), `--include` (URL path pattern to include), `--exclude` (URL path pattern to exclude) to existing crawl command

### New commands
- **D-03:** `firecrawl batch <url1> [url2 ...]` — POST `/v1/batch/scrape` with JSON `{"urls":["...",...]}` — scrape multiple URLs in a single request; display results as a list with URL, title, and word count per page
- **D-04:** `firecrawl cancel <job_id>` — DELETE `/v1/crawl/{id}` with `confirm_action` — cancel an in-progress crawl job by ID
- **D-05:** `firecrawl jobs` — GET `/v1/crawl` (list endpoint if available) or maintain a local job ID cache in `~/.cache/homelab-cli/firecrawl-jobs` — list known crawl jobs with ID, URL, status, page count, created time

</decisions>

<canonical_refs>
## Canonical References

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md (FC-01 through FC-05).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `bin/firecrawl` — 248 lines, 8 commands: scrape, crawl, status, map, search, extract, health + help
- `fc_get()` — unauthenticated GET: `curl -sf "${FC_URL}/v1/${endpoint}"`
- `fc_post()` — unauthenticated POST: `curl -sf -X POST -H "Content-Type: application/json" --data "${body}" "${FC_URL}/v1/${endpoint}"`
- `lib/common.sh` — confirm_action, color helpers, human_size

### Established Patterns
- No auth; FC_URL from config (typically http://localhost:3002)
- Async crawl pattern: POST returns `{"id":"..."}`, poll GET `/v1/crawl/{id}` until `status == "completed"`
- Python3 inline for JSON parsing and result formatting
- `die` for errors, `info`/`ok`/`warn` for status

### Integration Points
- Enhanced commands: update existing scrape/crawl case blocks with getopts-style flag parsing
- New commands added to bin/firecrawl main() case statement
- Help text updated: add flag docs to SCRAPE and CRAWL sections; add BATCH and JOB MANAGEMENT sections
- Firecrawl API: /v1/scrape (enhanced), /v1/crawl (enhanced + list), /v1/batch/scrape, /v1/crawl/{id} (GET for status, DELETE for cancel)

</code_context>

<deferred>
## Deferred Ideas

None

</deferred>

---

*Phase: 14-firecrawl*
*Context gathered: 2026-03-22*
