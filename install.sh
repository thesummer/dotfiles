#!/usr/bin/env bash
#
# Non-interactive dotfiles bootstrap.
#
# Designed to run unattended in a bash-only x86_64 container (e.g. via DevPod's
# `--dotfiles` flag): it asks no questions, needs no sudo/root, and installs all
# custom binaries under ~/.local/bin. Safe to re-run.

set -uo pipefail

# Resolve the repo root from this script's own location. Do NOT assume the repo
# lives at ~/.dotfiles; DevPod may clone it anywhere.
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export REPO_DIR

echo "Installing dotfiles from $REPO_DIR"

# Create a canonical ~/.dotfiles symlink so runtime config that references
# $HOME/.dotfiles (e.g. zshenv) keeps working regardless of clone location.
canonical="$HOME/.dotfiles"
repo_real="$(cd "$REPO_DIR" && pwd -P)"
if [ -e "$canonical" ] || [ -L "$canonical" ]; then
    existing_real="$(cd "$canonical" 2>/dev/null && pwd -P || true)"
    if [ "$existing_real" = "$repo_real" ]; then
        echo "$canonical already resolves to this repo; leaving it as is."
    else
        echo "warning: $canonical already exists and does not point to $REPO_DIR."
        echo "         leaving it untouched; runtime \$DOTFILES will use the existing target."
    fi
else
    echo "Linking $canonical -> $REPO_DIR"
    ln -s "$REPO_DIR" "$canonical"
fi

echo "Creating vim temp directory"
mkdir -p "$HOME/.vim-tmp"

# Install neovim / ripgrep / fzf / zsh into ~/.local/bin.
if ! bash "$REPO_DIR/install/tools.sh"; then
    echo "error: tool installation failed" >&2
    exit 1
fi

# Symlink *.symlink files and config/ entries into $HOME.
bash "$REPO_DIR/install/link.sh"

# Interactive git identity setup is intentionally left disabled (no questions).
# bash "$REPO_DIR/install/git.sh"

echo "Done."

