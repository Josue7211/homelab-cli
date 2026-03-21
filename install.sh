#!/usr/bin/env bash
# install.sh - Symlink homelab-cli tools into ~/.local/bin/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${HOME}/.local/bin"

mkdir -p "$BIN_DIR"

echo "Installing homelab-cli tools to $BIN_DIR..."
echo ""

installed=0
skipped=0

for script in "$SCRIPT_DIR"/bin/*; do
    [[ -f "$script" ]] || continue
    name="$(basename "$script")"
    target="$BIN_DIR/$name"

    # Make executable
    chmod +x "$script"

    if [[ -L "$target" ]]; then
        # Already a symlink — update it
        ln -sf "$script" "$target"
        echo "  updated: $name"
        installed=$((installed + 1))
    elif [[ -e "$target" ]]; then
        echo "  skipped: $name (file exists, not a symlink — back it up first)"
        skipped=$((skipped + 1))
    else
        ln -s "$script" "$target"
        echo "  linked:  $name"
        installed=$((installed + 1))
    fi
done

# Ensure lib is accessible
chmod +x "$SCRIPT_DIR/lib/common.sh"

echo ""
echo "Done. $installed installed, $skipped skipped."

# Check for config
if [[ ! -f "${HOME}/.config/homelab-cli/config" ]]; then
    echo ""
    echo "No config found. Set up your config:"
    echo "  mkdir -p ~/.config/homelab-cli"
    echo "  cp $SCRIPT_DIR/config.example ~/.config/homelab-cli/config"
    echo "  \$EDITOR ~/.config/homelab-cli/config"
fi
