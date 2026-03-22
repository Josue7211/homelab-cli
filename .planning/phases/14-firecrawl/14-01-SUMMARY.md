---
phase: 14-firecrawl
plan: 01
subsystem: cli
tags: [firecrawl, scraping, crawling, batch, bash, python3]

# Dependency graph
requires:
  - phase: 01-foundation
    provides: common.sh helpers (die, ok, info, warn, confirm_action)
provides:
  - Enhanced cmd_scrape with --wait and --headers flags
  - New cmd_batch for multi-URL batch scraping via /v1/batch/scrape
  - Enhanced cmd_crawl with --depth, --include, --exclude flags
affects: [14-firecrawl]

# Tech tracking
tech-stack:
  added: []
  patterns: [while-loop flag parsing with positional fallback, os.environ python3 JSON payload builder]

key-files:
  created: []
  modified: [bin/firecrawl]

key-decisions:
  - "Flag parsing uses while-loop with positional fallback for backward compat (format/outfile still work positionally)"
  - "Help text reorganized into SCRAPING/CRAWLING/DISCOVERY/SYSTEM sections with flag documentation"

patterns-established:
  - "Flag parsing pattern: positional args first, then --flag value pairs via while/case loop"
  - "Batch API pattern: newline-delimited URLs via env var, split in python3"

requirements-completed: [FC-01, FC-02, FC-03]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 14 Plan 01: Firecrawl Enhanced Scrape/Crawl/Batch Summary

**Enhanced scrape with --wait/--headers flags, new batch multi-URL command, and crawl with --depth/--include/--exclude filtering**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T12:15:00Z
- **Completed:** 2026-03-22T12:17:00Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- cmd_scrape now accepts --wait N (maps to waitFor in API) and --headers 'K:V,...' (parsed to JSON object) while preserving positional args
- New cmd_batch POSTs multiple URLs to /v1/batch/scrape with per-page title, URL, and word count display
- cmd_crawl now accepts --depth (maxDepth), --include (includePaths), --exclude (excludePaths) flags
- Help text reorganized into 4 sections with flag documentation and new examples

## Task Commits

Each task was committed atomically:

1. **Task 1: Enhance scrape with --wait/--headers and add batch command** - `714a13f` (feat)
2. **Task 2: Enhance crawl with --depth/--include/--exclude flags** - `8058e69` (feat)

## Files Created/Modified
- `bin/firecrawl` - Enhanced cmd_scrape, cmd_crawl with flag parsing; new cmd_batch; updated help text and case statement

## Decisions Made
- Flag parsing uses while-loop with positional fallback so existing `firecrawl scrape <url> <format> <outfile>` syntax still works
- Help text reorganized into SCRAPING/CRAWLING/DISCOVERY/SYSTEM sections to group related commands with their flags

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Scrape, crawl, and batch commands enhanced with new flags
- Ready for plan 02 (cancel and jobs commands)

## Self-Check: PASSED

All files exist and all commits verified.

---
*Phase: 14-firecrawl*
*Completed: 2026-03-22*
