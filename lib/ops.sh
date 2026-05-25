#!/usr/bin/env bash
# ops.sh - Homelab agent operations doctor, repair, fleet, and backups.

# Defaults can be overridden in ~/.config/homelab-cli/config.
HOMELAB_AGENT_VM_SSH="${HOMELAB_AGENT_VM_SSH:-aparcedodev@100.104.154.24}"
HOMELAB_AGENT_VM_HOST="${HOMELAB_AGENT_VM_HOST:-agent-vm}"
HOMELAB_AGENT_VM_IP="${HOMELAB_AGENT_VM_IP:-100.104.154.24}"
HOMELAB_AGENT_USER="${HOMELAB_AGENT_USER:-aparcedodev}"
HOMELAB_TAILSCALE_TAILNET="${HOMELAB_TAILSCALE_TAILNET:-josue7211.github}"
HOMELAB_TAILSCALE_API_BW_ENTRY="${HOMELAB_TAILSCALE_API_BW_ENTRY:-Tailscale API Key}"
HOMELAB_SUDO_BW_ENTRY="${HOMELAB_SUDO_BW_ENTRY:-homelab}"
HOMELAB_CODEX_LB_BW_ENTRY="${HOMELAB_CODEX_LB_BW_ENTRY:-Codex LB API Key - agent-vm}"
HOMELAB_CODEX_LB_URL="${HOMELAB_CODEX_LB_URL:-http://100.104.154.24:2455/v1/models}"
HOMELAB_VAULTWARDEN_URL="${HOMELAB_VAULTWARDEN_URL:-https://swaysvault.aparcedo.org}"
HOMELAB_MEMD_BUNDLE="${HOMELAB_MEMD_BUNDLE:-~/.hermes/hermes-agent/.memd}"
HOMELAB_STATE_DIR="${HOMELAB_STATE_DIR:-$HOME/.local/state/homelab-cli}"
HOMELAB_FLEET_USER="${HOMELAB_FLEET_USER:-aparcedodev}"
HOMELAB_FLEET_SOURCE_HOST="${HOMELAB_FLEET_SOURCE_HOST:-$HOMELAB_AGENT_VM_HOST}"
HOMELAB_FLEET_SOURCE_IP="${HOMELAB_FLEET_SOURCE_IP:-$HOMELAB_AGENT_VM_IP}"
HOMELAB_FLEET_BASE_URL="${HOMELAB_FLEET_BASE_URL:-http://100.104.154.24:8787}"

_ops_pass=0
_ops_fail=0
_ops_warn=0

ops_reset_counts() {
    _ops_pass=0
    _ops_fail=0
    _ops_warn=0
}

ops_ok() {
    _ops_pass=$((_ops_pass + 1))
    printf "  [+] %s\n" "$1"
}

ops_fail() {
    _ops_fail=$((_ops_fail + 1))
    printf "  [-] %s\n" "$1"
}

ops_warn() {
    _ops_warn=$((_ops_warn + 1))
    printf "  [!] %s\n" "$1"
}

ops_summary() {
    printf "\n  result: pass=%s warn=%s fail=%s\n" "$_ops_pass" "$_ops_warn" "$_ops_fail"
    [[ "$_ops_fail" -eq 0 ]]
}

ops_secret() {
    local entry="$1"
    get_secret bw "$entry" 2>/dev/null | tr -d '\r'
}

ops_tailnet() {
    if command -v tailscale >/dev/null 2>&1; then
        tailscale status --json 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin).get("CurrentTailnet",{}).get("Name",""))' 2>/dev/null \
            || true
    fi
}

ops_tailscale_token() {
    ops_secret "$HOMELAB_TAILSCALE_API_BW_ENTRY"
}

ops_codex_lb_key() {
    ops_secret "$HOMELAB_CODEX_LB_BW_ENTRY"
}

ops_sudo_password() {
    ops_secret "$HOMELAB_SUDO_BW_ENTRY"
}

ops_agent_ssh() {
    if ops_is_local_fleet_host "$HOMELAB_AGENT_VM_HOST" "$HOMELAB_AGENT_VM_IP"; then
        bash -lc "$1"
        return
    fi
    ssh -o BatchMode=yes -o ConnectTimeout=8 "$HOMELAB_AGENT_VM_SSH" "$@"
}

ops_is_local_fleet_host() {
    local host="$1" ip="$2" local_host local_ip
    local_host=$(hostname -s 2>/dev/null || hostname 2>/dev/null || true)
    local_ip=$(tailscale ip -4 2>/dev/null | head -1 || true)
    [[ -n "$host" && "$host" == "$local_host" ]] || [[ -n "$ip" && "$ip" == "$local_ip" ]]
}

ops_remote_exec() {
    local host="$1" ip="$2" cmd="$3"
    if ops_is_local_fleet_host "$host" "$ip"; then
        bash -lc "$cmd"
        return
    fi
    local target="${HOMELAB_FLEET_USER}@${ip:-$host}"
    ssh -n -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=accept-new "$target" "$cmd"
}

ops_remote_exec_with_stdin() {
    local host="$1" ip="$2" cmd="$3"
    if ops_is_local_fleet_host "$host" "$ip"; then
        bash -lc "$cmd"
        return
    fi
    local target="${HOMELAB_FLEET_USER}@${ip:-$host}"
    ssh -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=accept-new "$target" "$cmd"
}

ops_tailnet_devices_json() {
    local token tailnet
    token=$(ops_tailscale_token || true)
    tailnet="${HOMELAB_TAILSCALE_TAILNET:-$(ops_tailnet)}"
    [[ -n "$token" && -n "$tailnet" ]] || return 1
    curl -sS -H "Authorization: Bearer $token" "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices"
}

ops_fleet_server_rows() {
    local json
    json=$(ops_tailnet_devices_json) || return 1
    python3 - "$json" <<'PY'
import json,sys
devices=json.loads(sys.argv[1]).get("devices",[])
for d in sorted(devices, key=lambda x: x.get("hostname") or x.get("name","")):
    tags=d.get("tags") or []
    os=d.get("os","")
    if os != "linux" or "tag:server" not in tags:
        continue
    print("|".join([
        d.get("hostname") or d.get("name","").split(".")[0],
        (d.get("addresses") or [""])[0],
        os,
        ",".join(tags),
    ]))
PY
}

ops_check_cmd() {
    local cmd="$1"
    if command -v "$cmd" >/dev/null 2>&1; then
        ops_ok "local command: $cmd"
    else
        ops_fail "missing local command: $cmd"
    fi
}

ops_check_http() {
    local label="$1" url="$2" expect="${3:-200}" header="${4:-}"
    local code
    if [[ -n "$header" ]]; then
        code=$(curl -sS -o /tmp/homelab-ops-http.out -w '%{http_code}' --connect-timeout 5 -H "$header" "$url" 2>/dev/null || echo 000)
    else
        code=$(curl -sS -o /tmp/homelab-ops-http.out -w '%{http_code}' --connect-timeout 5 "$url" 2>/dev/null || echo 000)
    fi
    if [[ "$code" == "$expect" ]]; then
        ops_ok "$label HTTP $code"
    else
        ops_fail "$label HTTP $code expected $expect"
    fi
}

ops_check_bw() {
    if ! command -v bw >/dev/null 2>&1; then
        ops_fail "Bitwarden CLI missing"
        return
    fi
    local status server
    status=$(bw status 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin).get("status","unknown"))' 2>/dev/null || echo unknown)
    server=$(bw config server 2>/dev/null || true)
    if [[ "$server" == "$HOMELAB_VAULTWARDEN_URL" ]]; then
        ops_ok "Bitwarden server configured"
    else
        ops_fail "Bitwarden server is '$server'"
    fi
    case "$status" in
        unlocked) ops_ok "Bitwarden CLI unlocked" ;;
        locked) ops_warn "Bitwarden CLI locked; export BW_SESSION for secret-backed checks" ;;
        unauthenticated) ops_warn "Bitwarden CLI unauthenticated on this machine" ;;
        *) ops_warn "Bitwarden status: $status" ;;
    esac
}

ops_check_tailnet_acl() {
    local token tailnet body
    token=$(ops_tailscale_token || true)
    tailnet="${HOMELAB_TAILSCALE_TAILNET:-$(ops_tailnet)}"
    if [[ -z "$token" || -z "$tailnet" ]]; then
        ops_fail "Tailscale API token/tailnet unavailable"
        return
    fi
    body=$(curl -sS -H "Authorization: Bearer $token" "https://api.tailscale.com/api/v2/tailnet/$tailnet/acl" 2>/dev/null || true)
    if python3 - "$body" <<'PY'
import sys
s=sys.argv[1]
ok = '"autogroup:member"' in s and '"*:*"' in s and '"ssh"' in s and '"tag:server"' in s
sys.exit(0 if ok else 1)
PY
    then
        ops_ok "Tailscale ACL broad access + SSH policy"
    else
        ops_fail "Tailscale ACL missing broad access or SSH policy"
    fi
}

ops_check_tailnet_devices() {
    local token tailnet json
    token=$(ops_tailscale_token || true)
    tailnet="${HOMELAB_TAILSCALE_TAILNET:-$(ops_tailnet)}"
    if [[ -z "$token" || -z "$tailnet" ]]; then
        ops_fail "Tailscale devices unavailable"
        return
    fi
    json=$(curl -sS -H "Authorization: Bearer $token" "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" 2>/dev/null || true)
    if python3 - "$json" <<'PY'
import json,sys
try:
    devices=json.loads(sys.argv[1]).get("devices",[])
except Exception:
    sys.exit(1)
names=" ".join((d.get("name","")+" "+d.get("hostname","")).lower() for d in devices)
need=["agent-vm","iphone","ipad"]
sys.exit(0 if all(n in names for n in need) else 1)
PY
    then
        ops_ok "Tailscale devices include agent-vm, iPhone, iPad"
    else
        ops_fail "Tailscale device set missing agent-vm/iPhone/iPad"
    fi
}

ops_check_agent_vm() {
    if ! ops_agent_ssh 'true' >/dev/null 2>&1; then
        ops_fail "SSH to $HOMELAB_AGENT_VM_SSH"
        return
    fi
    ops_ok "SSH to $HOMELAB_AGENT_VM_SSH"
    local out
    out=$(ops_agent_ssh 'set -e
printf "bw="; command -v bw || true
printf "bw_version="; bw --version 2>/dev/null || true
printf "codex="; command -v codex || true
printf "codex_version="; codex --version 2>/dev/null || true
printf "memd="; command -v memd || true
printf "memd_status="; memd status --output ~/.hermes/hermes-agent/.memd --summary 2>/dev/null || true
printf "hermes_services="; systemctl --user is-active hermes-api-server 2>/dev/null | tr -d "\n"; printf ","; systemctl --user is-active hermes-openclaw-compat 2>/dev/null || true
printf "runssh="; tailscale debug prefs 2>/dev/null | jq -r .RunSSH 2>/dev/null || true
. ~/.config/clawcontrol-hermes.env >/dev/null 2>&1 || true
printf "hermes_health="; curl -sS -o /tmp/homelab-hermes-health.json -w "%{http_code}" -H "Authorization: Bearer ${API_SERVER_KEY:-}" http://127.0.0.1:8642/health 2>/dev/null || true
printf "\n"')
    [[ "$out" == *"bw_version=2026."* ]] && ops_ok "agent-vm Bitwarden CLI" || ops_fail "agent-vm Bitwarden CLI"
    [[ "$out" == *"codex_version=codex-cli"* ]] && ops_ok "agent-vm Codex CLI" || ops_fail "agent-vm Codex CLI"
    [[ "$out" == *"ready=true setup=true"* ]] && ops_ok "agent-vm memd ready" || ops_fail "agent-vm memd not ready"
    [[ "$out" == *"hermes_services=active,active"* ]] && ops_ok "Hermes services active" || ops_fail "Hermes services not active"
    [[ "$out" == *"runssh=true"* ]] && ops_ok "Tailscale SSH enabled on agent-vm" || ops_fail "Tailscale SSH disabled on agent-vm"
    [[ "$out" == *"hermes_health=200"* ]] && ops_ok "Hermes API health" || ops_fail "Hermes API health"
}

ops_check_codex_lb() {
    local key code
    key=$(ops_codex_lb_key || true)
    if [[ -z "$key" ]]; then
        ops_fail "Codex LB key unavailable"
        return
    fi
    code=$(curl -sS -o /tmp/homelab-codex-lb.json -w '%{http_code}' -H "Authorization: Bearer $key" "$HOMELAB_CODEX_LB_URL" 2>/dev/null || echo 000)
    if [[ "$code" == "200" ]]; then
        ops_ok "Codex LB models endpoint"
    else
        ops_fail "Codex LB HTTP $code"
    fi
}

ops_check_vaultwarden() {
    local code
    code=$(curl -sS -o /tmp/homelab-vaultwarden-identity.json -w '%{http_code}' \
        -X POST "$HOMELAB_VAULTWARDEN_URL/identity/connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --data "grant_type=password&username=probe&password=probe&scope=api offline_access" 2>/dev/null || echo 000)
    if [[ "$code" == "400" ]]; then
        ops_ok "Vaultwarden identity route"
    else
        ops_fail "Vaultwarden identity route HTTP $code"
    fi
}

cmd_doctor() {
    ops_reset_counts
    header "HOMELAB DOCTOR"
    for cmd in bw tailscale jq curl ssh python3; do
        ops_check_cmd "$cmd"
    done
    ops_check_bw
    ops_check_tailnet_acl
    ops_check_tailnet_devices
    ops_check_vaultwarden
    ops_check_agent_vm
    ops_check_codex_lb
    ops_summary
}

cmd_dashboard_ops() {
    cmd_doctor
}

cmd_repair_ops() {
    header "HOMELAB REPAIR"
    local token tailnet sudo_pass
    token=$(ops_tailscale_token || true)
    tailnet="${HOMELAB_TAILSCALE_TAILNET:-$(ops_tailnet)}"
    if [[ -n "$token" && -n "$tailnet" ]]; then
        local policy
        policy=$(mktemp)
        cat > "$policy" <<'POLICY'
{
  "acls": [
    {
      "action": "accept",
      "src": ["autogroup:member", "tag:server", "tag:router", "tag:desktop"],
      "dst": ["*:*"]
    }
  ],
  "ssh": [
    {
      "action": "accept",
      "src": ["autogroup:member"],
      "dst": ["autogroup:self", "tag:server", "tag:router", "tag:desktop"],
      "users": ["autogroup:nonroot", "aparcedodev", "josue"]
    },
    {
      "action": "accept",
      "src": ["tag:server", "tag:router", "tag:desktop"],
      "dst": ["tag:server", "tag:router"],
      "users": ["autogroup:nonroot", "aparcedodev"]
    },
    {
      "action": "accept",
      "src": ["tag:server", "tag:router", "tag:desktop"],
      "dst": ["tag:desktop"],
      "users": ["josue"]
    }
  ],
  "tagOwners": {
    "tag:server": ["autogroup:admin"],
    "tag:router": ["autogroup:admin"],
    "tag:desktop": ["autogroup:admin"]
  },
  "autoApprovers": {
    "routes": {
      "10.0.0.0/24": ["tag:router"],
      "10.10.10.0/24": ["tag:router"],
      "10.30.30.0/24": ["tag:router"],
      "10.40.40.0/24": ["tag:router"],
      "10.50.50.0/24": ["tag:router"],
      "0.0.0.0/0": ["tag:router"]
    }
  }
}
POLICY
        local code
        code=$(curl -sS -o /tmp/homelab-tailnet-acl-repair.out -w '%{http_code}' \
            -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" \
            --data-binary "@$policy" "https://api.tailscale.com/api/v2/tailnet/$tailnet/acl" 2>/dev/null || echo 000)
        rm -f "$policy"
        [[ "$code" == "200" ]] && ops_ok "reapplied Tailscale ACL" || ops_fail "Tailscale ACL repair HTTP $code"
    else
        ops_fail "cannot repair Tailscale ACL without API token"
    fi

    if ops_agent_ssh 'true' >/dev/null 2>&1; then
        sudo_pass=$(ops_sudo_password || true)
        if ops_agent_ssh 'tailscale set --operator=aparcedodev >/dev/null 2>&1; tailscale set --ssh --accept-risk=lose-ssh >/dev/null 2>&1'; then
            ops_ok "repaired agent-vm Tailscale operator/SSH"
        elif [[ -n "$sudo_pass" ]]; then
            printf '%s\n' "$sudo_pass" | ops_agent_ssh 'read -r SUDO_PASS
printf "%s\n" "$SUDO_PASS" | sudo -S -p "" tailscale set --operator=aparcedodev >/dev/null
tailscale set --ssh --accept-risk=lose-ssh >/dev/null
' >/dev/null 2>&1 && ops_ok "repaired agent-vm Tailscale operator/SSH with sudo" || ops_fail "agent-vm Tailscale repair failed"
        else
            ops_fail "agent-vm sudo secret unavailable"
        fi
        ops_agent_ssh 'systemctl --user restart hermes-api-server hermes-openclaw-compat >/dev/null 2>&1 || true' \
            && ops_ok "restarted Hermes services" || ops_fail "Hermes restart failed"
    else
        ops_fail "cannot SSH to agent-vm for repair"
    fi
    ops_summary
}

cmd_backup_ops() {
    local stamp dir token tailnet
    stamp=$(date +%Y%m%d-%H%M%S)
    dir="$HOMELAB_STATE_DIR/backups/$stamp"
    mkdir -p "$dir"
    chmod 700 "$HOMELAB_STATE_DIR" "$HOMELAB_STATE_DIR/backups" "$dir" 2>/dev/null || true
    header "HOMELAB BACKUP"
    token=$(ops_tailscale_token || true)
    tailnet="${HOMELAB_TAILSCALE_TAILNET:-$(ops_tailnet)}"
    if [[ -n "$token" && -n "$tailnet" ]]; then
        curl -sS -H "Authorization: Bearer $token" "https://api.tailscale.com/api/v2/tailnet/$tailnet/acl" > "$dir/tailscale-acl.hujson" || true
        curl -sS -H "Authorization: Bearer $token" "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" > "$dir/tailscale-devices.json" || true
        ops_ok "backed up Tailscale ACL/devices"
    else
        ops_warn "skipped Tailscale backup: API token unavailable"
    fi
    if ops_agent_ssh 'true' >/dev/null 2>&1; then
        ops_agent_ssh 'set -e
mkdir -p /tmp/homelab-backup
systemctl --user cat hermes-api-server hermes-openclaw-compat > /tmp/homelab-backup/hermes-systemd-user-units.txt 2>/dev/null || true
cp ~/.hermes/config.yaml /tmp/homelab-backup/hermes-config.yaml 2>/dev/null || true
memd status --output ~/.hermes/hermes-agent/.memd --summary > /tmp/homelab-backup/memd-status.txt 2>/dev/null || true
{ bw --version; bw config server; codex --version; memd status --output ~/.hermes/hermes-agent/.memd --summary; } > /tmp/homelab-backup/versions.txt 2>/dev/null || true
for f in ~/.config/clawcontrol-hermes.env ~/.config/clawcontrol-hermes-compat.env; do
  b=$(basename "$f")
  if [ -f "$f" ]; then sed -E "s/^([A-Za-z0-9_]+)=.*/\1=<redacted>/" "$f" > "/tmp/homelab-backup/$b.redacted"; fi
done
' >/dev/null
        rsync -a --delete "$HOMELAB_AGENT_VM_SSH:/tmp/homelab-backup/" "$dir/agent-vm/" >/dev/null
        ops_ok "backed up agent-vm Hermes/memd/Codex config"
    else
        ops_warn "skipped agent-vm backup: SSH unavailable"
    fi
    local row host ip os tags
    mkdir -p "$dir/fleet"
    while IFS='|' read -r host ip os tags; do
        [[ -n "$host" && -n "$ip" ]] || continue
        if ops_remote_exec "$host" "$ip" 'true' >/dev/null 2>&1; then
            ops_remote_exec "$host" "$ip" '
{
  printf "hostname="; hostname
  printf "bw="; bw --version 2>/dev/null || true
  printf "bw_server="; bw config server 2>/dev/null || true; printf "\n"
  printf "codex="; codex --version 2>/dev/null || true
  printf "memd="; memd status --summary 2>/dev/null || true
  printf "tailscale_ssh="; tailscale debug prefs 2>/dev/null | jq -r ".RunSSH,.OperatorUser" 2>/dev/null | paste -sd "," -
}
' > "$dir/fleet/$host.txt" 2>/dev/null || true
        fi
    done < <(ops_fleet_server_rows)
    ops_ok "backed up fleet baseline status"
    printf "  backup_dir=%s\n" "$dir"
}

cmd_fleet_ops() {
    header "HOMELAB FLEET"
    local token tailnet json
    token=$(ops_tailscale_token || true)
    tailnet="${HOMELAB_TAILSCALE_TAILNET:-$(ops_tailnet)}"
    if [[ -z "$token" || -z "$tailnet" ]]; then
        die "Tailscale API token/tailnet unavailable"
    fi
    json=$(curl -sS -H "Authorization: Bearer $token" "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices")
    python3 - "$json" <<'PY'
import json,sys
devices=json.loads(sys.argv[1]).get("devices",[])
print("  Name|Host|IP|OS|Tags|Last seen")
print("  ---|---|---|---|---|---")
for d in sorted(devices, key=lambda x: x.get("name","")):
    print("  {name}|{host}|{ip}|{os}|{tags}|{last}".format(
        name=d.get("name",""),
        host=d.get("hostname",""),
        ip=(d.get("addresses") or [""])[0],
        os=d.get("os",""),
        tags=",".join(d.get("tags") or []),
        last=d.get("lastSeen","never"),
    ))
PY
}

ops_fleet_check_host() {
    local host="$1" ip="$2"
    local label="$host ($ip)"
    local out
    if ! out=$(ops_remote_exec "$host" "$ip" 'set -e
printf "host="; hostname
for c in node npm bw codex memd jq curl tailscale; do printf "%s=" "$c"; command -v "$c" || true; done
printf "bw_version="; bw --version 2>/dev/null || true
printf "bw_server="; bw config server 2>/dev/null || true
printf "codex_version="; codex --version 2>/dev/null || true
printf "memd_status="; memd status --summary 2>/dev/null || true
printf "runssh="; tailscale debug prefs 2>/dev/null | jq -r .RunSSH 2>/dev/null || true
' 2>/dev/null); then
        ops_fail "$label SSH"
        return
    fi
    ops_ok "$label SSH"
    [[ "$out" == *"bw_version=2026."* ]] && ops_ok "$label Bitwarden CLI" || ops_fail "$label Bitwarden CLI"
    [[ "$out" == *"bw_server=$HOMELAB_VAULTWARDEN_URL"* ]] && ops_ok "$label Vaultwarden config" || ops_fail "$label Vaultwarden config"
    [[ "$out" == *"codex_version=codex-cli"* ]] && ops_ok "$label Codex CLI" || ops_fail "$label Codex CLI"
    [[ "$out" == *"ready=true setup=true"* ]] && ops_ok "$label memd ready" || ops_fail "$label memd ready"
    [[ "$out" == *"runssh=true"* ]] && ops_ok "$label Tailscale SSH" || ops_fail "$label Tailscale SSH"
}

cmd_fleet_doctor_ops() {
    ops_reset_counts
    header "HOMELAB FLEET DOCTOR"
    local row host ip os tags
    while IFS='|' read -r host ip os tags; do
        [[ -n "$host" && -n "$ip" ]] || continue
        ops_fleet_check_host "$host" "$ip"
    done < <(ops_fleet_server_rows)
    ops_summary
}

ops_sync_codex_surface() {
    local host="$1" ip="$2"
    local item
    [[ "$host" == "$HOMELAB_FLEET_SOURCE_HOST" || "$ip" == "$HOMELAB_FLEET_SOURCE_IP" ]] && return 0
    ops_remote_exec "$host" "$ip" 'mkdir -p ~/.codex ~/.local/bin ~/memd/integrations ~/memd/crates/memd-client' >/dev/null
    for item in memd memd-server; do
        if ops_remote_exec "$HOMELAB_FLEET_SOURCE_HOST" "$HOMELAB_FLEET_SOURCE_IP" "test -x ~/.local/bin/$item" >/dev/null 2>&1; then
            ops_remote_exec "$HOMELAB_FLEET_SOURCE_HOST" "$HOMELAB_FLEET_SOURCE_IP" "tar -C ~/.local/bin -czf - '$item'" \
                | ops_remote_exec_with_stdin "$host" "$ip" 'tar -C ~/.local/bin -xzf -'
        fi
    done
    ops_remote_exec "$HOMELAB_FLEET_SOURCE_HOST" "$HOMELAB_FLEET_SOURCE_IP" 'tar -C ~/memd/integrations -czf - hooks' \
        | ops_remote_exec_with_stdin "$host" "$ip" 'tar -C ~/memd/integrations -xzf -'
    for item in agents commands hooks skills config.toml hooks.json .personality_migration; do
        if ops_remote_exec "$HOMELAB_FLEET_SOURCE_HOST" "$HOMELAB_FLEET_SOURCE_IP" "test -e ~/.codex/$item" >/dev/null 2>&1; then
            ops_remote_exec "$HOMELAB_FLEET_SOURCE_HOST" "$HOMELAB_FLEET_SOURCE_IP" "tar -C ~/.codex -czf - '$item'" \
                | ops_remote_exec_with_stdin "$host" "$ip" 'tar -C ~/.codex -xzf -'
        fi
    done
}

ops_sync_host_baseline() {
    local host="$1" ip="$2" sudo_pass="$3"
    local label="$host ($ip)"
    if ! ops_remote_exec "$host" "$ip" 'true' >/dev/null 2>&1; then
        ops_warn "$label SSH unavailable; skipped baseline"
        return 0
    fi
    printf '%s\n' "$sudo_pass" | ops_remote_exec_with_stdin "$host" "$ip" '
set -e
read -r SUDO_PASS
if command -v apt-get >/dev/null 2>&1; then
  missing=""
  command -v curl >/dev/null 2>&1 || missing="$missing curl"
  command -v jq >/dev/null 2>&1 || missing="$missing jq"
  command -v node >/dev/null 2>&1 || missing="$missing nodejs"
  command -v npm >/dev/null 2>&1 || missing="$missing npm"
  if [ -n "$missing" ]; then
    printf "%s\n" "$SUDO_PASS" | sudo -S -p "" apt-get update >/dev/null
    printf "%s\n" "$SUDO_PASS" | sudo -S -p "" DEBIAN_FRONTEND=noninteractive apt-get install -y $missing >/dev/null
  fi
fi
mkdir -p ~/.npm-global ~/.local/bin ~/memd/crates/memd-client
npm config set prefix ~/.npm-global >/dev/null
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
if ! command -v bw >/dev/null 2>&1 || ! command -v codex >/dev/null 2>&1; then
  npm install -g @bitwarden/cli @openai/codex >/dev/null
fi
for file in ~/.profile ~/.bashrc ~/.zshrc; do
  touch "$file"
  grep -qxF "export PATH=\"\$HOME/.npm-global/bin:\$HOME/.local/bin:\$PATH\"" "$file" || printf "\nexport PATH=\"\$HOME/.npm-global/bin:\$HOME/.local/bin:\$PATH\"\n" >> "$file"
done
printf "%s\n" "$SUDO_PASS" | sudo -S -p "" ln -sf "$HOME/.npm-global/bin/bw" /usr/local/bin/bw
printf "%s\n" "$SUDO_PASS" | sudo -S -p "" ln -sf "$HOME/.npm-global/bin/codex" /usr/local/bin/codex
if [ -x "$HOME/.local/bin/memd" ]; then
  printf "%s\n" "$SUDO_PASS" | sudo -S -p "" ln -sf "$HOME/.local/bin/memd" /usr/local/bin/memd
fi
if [ -x "$HOME/.local/bin/memd-server" ]; then
  printf "%s\n" "$SUDO_PASS" | sudo -S -p "" ln -sf "$HOME/.local/bin/memd-server" /usr/local/bin/memd-server
fi
bw config server '"$HOMELAB_VAULTWARDEN_URL"' >/dev/null
printf "%s\n" "$SUDO_PASS" | sudo -S -p "" tailscale set --operator='"$HOMELAB_FLEET_USER"' >/dev/null 2>&1 || true
tailscale set --ssh --accept-risk=lose-ssh >/dev/null 2>&1 || true
' >/dev/null
    ops_sync_codex_surface "$host" "$ip" >/dev/null
    printf '%s\n' "$sudo_pass" | ops_remote_exec_with_stdin "$host" "$ip" '
read -r SUDO_PASS
if [ -x "$HOME/.local/bin/memd" ]; then
  printf "%s\n" "$SUDO_PASS" | sudo -S -p "" ln -sf "$HOME/.local/bin/memd" /usr/local/bin/memd
fi
if [ -x "$HOME/.local/bin/memd-server" ]; then
  printf "%s\n" "$SUDO_PASS" | sudo -S -p "" ln -sf "$HOME/.local/bin/memd-server" /usr/local/bin/memd-server
fi
' >/dev/null
    ops_remote_exec "$host" "$ip" 'memd setup --agent codex --project '"$host"' --namespace main --base-url '"$HOMELAB_FLEET_BASE_URL"' --route auto --voice-mode caveman-lite --force --summary >/dev/null' >/dev/null
    ops_ok "$label baseline synced"
}

cmd_fleet_sync_ops() {
    ops_reset_counts
    header "HOMELAB FLEET SYNC"
    local sudo_pass row host ip os tags
    sudo_pass=$(ops_sudo_password || true)
    [[ -n "$sudo_pass" ]] || die "sudo secret unavailable from Bitwarden entry '$HOMELAB_SUDO_BW_ENTRY'"
    while IFS='|' read -r host ip os tags; do
        [[ -n "$host" && -n "$ip" ]] || continue
        ops_sync_host_baseline "$host" "$ip" "$sudo_pass"
    done < <(ops_fleet_server_rows)
    ops_summary
}
