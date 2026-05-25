# OpenCLI Registration

- This repo is the updates/integration team for the entire homelab.
- CLIs must be feature-rich enough for Claude (and AI agents) to manage the homelab autonomously.
- When adding commands, check if the service has new API endpoints not yet covered.
- Every operation an AI agent might need should be exposed as a CLI command.
- Install via `./install.sh` which symlinks `bin/*` into `~/.local/bin/`.
