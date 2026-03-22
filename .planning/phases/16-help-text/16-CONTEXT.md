# Phase 16: Help Text - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Audit and fix all CLI help texts to accurately reflect every command added in phases 1-15. Each CLI's cmd_help() should list all available commands with correct descriptions.

</domain>

<decisions>
## Implementation Decisions

### Claude's Discretion
All implementation choices are at Claude's discretion — pure infrastructure phase. Each CLI's help text was already updated during its phase execution, so this phase focuses on cross-cutting audit and any corrections needed.

</decisions>

<code_context>
## Existing Code Insights

### Reusable Assets
- Each CLI binary in bin/ has a cmd_help() function
- Help text follows consistent section-based format (SECTION: command description)

### Established Patterns
- show_version "cli-name" called at top of cmd_help
- Heredoc-style help with cat <<'HELP' ... HELP
- Sections organized by functional area

### Integration Points
- All 14 CLI binaries in bin/ directory

</code_context>

<specifics>
## Specific Ideas

No specific requirements — infrastructure phase

</specifics>

<deferred>
## Deferred Ideas

None

</deferred>
