#!/usr/bin/env bash
# common.sh - Shared helpers for homelab-cli tools
# Source this at the top of every CLI: source "$(dirname "$0")/../lib/common.sh"

set -euo pipefail

# ── Config loading ───────────────────────────────────────────────
HOMELAB_CONFIG="${HOMELAB_CONFIG:-$HOME/.config/homelab-cli/config}"

if [[ -f "$HOMELAB_CONFIG" ]]; then
    # shellcheck disable=SC1090
    source "$HOMELAB_CONFIG"
fi

# ── Colors ───────────────────────────────────────────────────────
if [[ -t 1 ]]; then
    RED='\033[0;31m'    GREEN='\033[0;32m'  YELLOW='\033[0;33m'
    BLUE='\033[0;34m'   CYAN='\033[0;36m'   BOLD='\033[1m'
    DIM='\033[2m'       RESET='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' RESET=''
fi

# ── Output helpers ───────────────────────────────────────────────
info()  { echo -e "${CYAN}${1}${RESET}"; }
ok()    { echo -e "${GREEN}${1}${RESET}"; }
warn()  { echo -e "${YELLOW}${1}${RESET}" >&2; }
err()   { echo -e "${RED}Error: ${1}${RESET}" >&2; }
die()   { err "$1"; exit 1; }
header(){ echo -e "\n${BOLD}  $1${RESET}"; echo "  ─────────────────────────────────────────────────────"; }

# ── Confirmation helper ─────────────────────────────────────────
# Usage: confirm_action "Delete stack 'myapp'?"
#   Prompts "Are you sure? (y/N)" and exits 1 if user doesn't type y/Y.
#   Respects HOMELAB_YES=1 env var to skip prompt (for scripting).
confirm_action() {
    local msg="${1:-Proceed?}"
    if [[ "${HOMELAB_YES:-0}" == "1" ]]; then
        return 0
    fi
    echo -en "${YELLOW}${msg} Are you sure? (y/N): ${RESET}"
    read -r answer
    case "$answer" in
        [yY]) return 0 ;;
        *) echo "Aborted."; exit 1 ;;
    esac
}

# ── Secret retrieval ─────────────────────────────────────────────
# Usage: get_secret <source> [bw_entry] [env_var] [file_path]
#   source: bw | env | file | config | value
#   For "config": reads API key from *arr config.xml via SSH
get_secret() {
    local source="${1:-}" bw_entry="${2:-}" env_var="${3:-}" file_path="${4:-}"

    case "$source" in
        bw)
            [[ -z "$bw_entry" ]] && die "bw entry name required"
            bw get password "$bw_entry" 2>/dev/null \
                || die "Can't get '$bw_entry' from vault. Is it unlocked? (bw unlock)"
            ;;
        env)
            local var="${env_var:-API_KEY}"
            [[ -z "${!var:-}" ]] && die "Environment variable $var is not set"
            echo "${!var}"
            ;;
        file)
            [[ -z "$file_path" ]] && die "File path required for secret"
            [[ -f "$file_path" ]] || die "Secret file not found: $file_path"
            cat "$file_path"
            ;;
        config)
            # Read API key from *arr config.xml or config.yaml (local or via SSH)
            local ssh_host="${5:-}" config_path="${6:-$file_path}"
            [[ -z "$config_path" ]] && die "Config path required"
            local cmd
            if [[ "$config_path" == *.yaml || "$config_path" == *.yml ]]; then
                # YAML: get first non-empty apikey value
                cmd="grep -m1 'apikey:' '$config_path' | head -1 | sed \"s/.*apikey: *['\\\"]\\{0,1\\}\\([^'\\\"]*\\)['\\\"]\\{0,1\\}/\\1/\" | tr -d ' '"
            else
                # XML: <ApiKey>value</ApiKey>
                cmd="grep -oP '(?<=<ApiKey>)[^<]+' '$config_path'"
            fi
            if [[ -n "$ssh_host" ]]; then
                ssh -o ConnectTimeout=5 "$ssh_host" "$cmd" 2>/dev/null \
                    || die "Can't read API key from $ssh_host:$config_path"
            else
                eval "$cmd" 2>/dev/null \
                    || die "Can't read API key from $config_path"
            fi
            ;;
        value)
            # Direct value (for testing or simple setups)
            echo "$bw_entry"
            ;;
        *)
            die "Unknown secret source: '$source' (expected: bw, env, file, config, value)"
            ;;
    esac
}

# ── API helpers ──────────────────────────────────────────────────
# Generic JSON API call
api_get() {
    local url="$1" api_key="${2:-}"
    local -a headers=()
    [[ -n "$api_key" ]] && headers+=(-H "X-Api-Key: $api_key")
    curl -sf "$url" "${headers[@]}" 2>/dev/null
}

api_post() {
    local url="$1" api_key="${2:-}" data="${3:-}"
    local -a headers=(-H "Content-Type: application/json")
    [[ -n "$api_key" ]] && headers+=(-H "X-Api-Key: $api_key")
    if [[ -n "$data" ]]; then
        curl -sf -X POST "$url" "${headers[@]}" -d "$data" 2>/dev/null
    else
        curl -sf -X POST "$url" "${headers[@]}" 2>/dev/null
    fi
}

api_delete() {
    local url="$1" api_key="${2:-}"
    local -a headers=()
    [[ -n "$api_key" ]] && headers+=(-H "X-Api-Key: $api_key")
    curl -sf -X DELETE "$url" "${headers[@]}" 2>/dev/null
}

api_put() {
    local url="$1" api_key="${2:-}" data="${3:-}"
    local -a headers=(-H "Content-Type: application/json")
    [[ -n "$api_key" ]] && headers+=(-H "X-Api-Key: $api_key")
    curl -sf -X PUT "$url" "${headers[@]}" -d "$data" 2>/dev/null
}

api_patch() {
    local url="$1" api_key="${2:-}" data="${3:-}"
    local -a headers=(-H "Content-Type: application/json")
    [[ -n "$api_key" ]] && headers+=(-H "X-Api-Key: $api_key")
    curl -sf -X PATCH "$url" "${headers[@]}" -d "$data" 2>/dev/null
}

# ── Formatting helpers ───────────────────────────────────────────
# Human-readable file sizes
human_size() {
    local bytes="${1:-0}"
    python3 -c "
b=$bytes
for u in ['B','KB','MB','GB','TB']:
    if b < 1024: print(f'{b:.1f} {u}'); break
    b /= 1024
"
}

# Table formatting
# Usage: echo "col1|col2|col3" | format_table
format_table() {
    column -t -s '|'
}

# JSON pretty print
json_pp() {
    python3 -m json.tool 2>/dev/null || cat
}

# ── Usage helper ─────────────────────────────────────────────────
# Call this in each CLI's usage function
show_version() {
    local name="$1"
    echo -e "${BOLD}${name}${RESET} ${DIM}(homelab-cli)${RESET}"
}

# ── Requirement checks ──────────────────────────────────────────
require_cmd() {
    local cmd="$1"
    command -v "$cmd" &>/dev/null || die "'$cmd' is required but not installed"
}

require_python() { require_cmd python3; }
require_jq()     { require_cmd jq; }
require_curl()   { require_cmd curl; }
