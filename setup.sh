#!/bin/sh
# setup.sh — put bonsai-ctl on your PATH.
#
# Creates a symlink in ~/.local/bin and overwrites any existing one.
# It does NOT modify any of your shell rc files (zshrc, bashrc, profile, ...).
# If ~/.local/bin is not already on your PATH, it prints the single line you
# should add to your shell rc, and you add it yourself.
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"
CTL="${DIR}/bonsai-ctl"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

if [ ! -f "${CTL}" ]; then
    echo "bonsai-ctl not found at ${CTL}" >&2
    exit 1
fi
chmod +x "${CTL}"

mkdir -p "${BIN_DIR}"

# Replace an existing symlink or stale file with a fresh link to this copy.
[ -L "${BIN_DIR}/bonsai-ctl" ] && rm -f "${BIN_DIR}/bonsai-ctl"
[ -f "${BIN_DIR}/bonsai-ctl" ] && rm -f "${BIN_DIR}/bonsai-ctl"
ln -s "${CTL}" "${BIN_DIR}/bonsai-ctl"
echo "Linked ${BIN_DIR}/bonsai-ctl -> ${CTL}"

# Is $BIN_DIR already a whole element of $PATH? (wrapped in colons -> exact match)
path_has() {
    printf ':%s:\n' "${PATH:-}" | grep -Fq ":${1}:"
}

if path_has "${BIN_DIR}"; then
    echo ""
    echo "bonsai-ctl is ready — ${BIN_DIR} is already on your PATH."
    echo "  Try: bonsai-ctl help"
else
    echo ""
    echo "${BIN_DIR}/bonsai-ctl is linked, but ${BIN_DIR} is not on your PATH."
    echo "Add this one line to your shell rc (e.g. ~/.zshrc or ~/.profile), then"
    echo "open a new terminal window:"
    printf '  export PATH="%s:%s"\n' "${BIN_DIR}" '$PATH'
fi
