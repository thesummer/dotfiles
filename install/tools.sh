#!/usr/bin/env bash
#
# Non-interactive installation of neovim, ripgrep, fzf and (if needed) zsh into
# $HOME/.local/bin. No sudo/root, no prompts, x86_64 Linux only.
#
# Behaviour:
#   * A tool already on PATH is skipped.
#   * Otherwise the current *latest stable* release is downloaded and installed.
#   * If the "latest" lookup or download fails (offline / rate-limited), that
#     tool fails loudly with a non-zero exit rather than falling back to a
#     pinned or stale version.
#
# Requires: bash, tar, mktemp, and curl or wget.

set -uo pipefail

LOCAL_PREFIX="$HOME/.local"
BIN_DIR="$LOCAL_PREFIX/bin"
OPT_DIR="$LOCAL_PREFIX/opt"

# Make previously-installed tools visible so skip-if-present works even when
# ~/.local/bin is not yet on PATH (a bash-only base image may not add it).
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) PATH="$BIN_DIR:$PATH" ;;
esac
export PATH

mkdir -p "$BIN_DIR" "$OPT_DIR"

info() { printf 'tools.sh: %s\n' "$*"; }
err()  { printf 'tools.sh: error: %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

# --- download URL -> DEST (curl preferred, wget fallback) ------------------
download() {
    local url="$1" dest="$2"
    if have curl; then
        curl -fsSL -o "$dest" -- "$url"
    elif have wget; then
        wget -qO "$dest" -- "$url"
    else
        err "need curl or wget to download files"
        return 1
    fi
}

# --- resolve latest release tag via the /releases/latest redirect ----------
# Prints the tag (e.g. "v0.12.3" or "15.1.0") on stdout. Avoids the GitHub API
# (and its rate limit). Fails loudly if the tag cannot be determined.
latest_tag() {
    local repo="$1" url="https://github.com/$1/releases/latest" effective="" tag
    if have curl; then
        effective="$(curl -fsSLI -o /dev/null -w '%{url_effective}' -- "$url")" || effective=""
    elif have wget; then
        effective="$(wget -S --max-redirect=10 --spider -- "$url" 2>&1 \
                     | awk '/^[[:space:]]*Location:/{print $2}' | tail -n1)" || effective=""
    else
        err "need curl or wget to resolve latest release for $repo"
        return 1
    fi
    tag="${effective##*/tag/}"     # strip up to and including "/tag/"
    tag="${tag%%[?#]*}"            # drop any query/fragment
    if [ -z "$tag" ] || [ "$tag" = "$effective" ]; then
        err "could not resolve latest release tag for $repo (offline or rate-limited?)"
        return 1
    fi
    printf '%s\n' "$tag"
}

# --- neovim (neovim/neovim-releases: glibc 2.17, runs old + new hosts) -----
install_neovim() {
    if have nvim; then
        info "nvim already present ($(command -v nvim)); skipping"
        return 0
    fi
    info "installing neovim (latest stable from neovim/neovim-releases)"
    local tag url tmp dir
    tag="$(latest_tag neovim/neovim-releases)" || return 1
    url="https://github.com/neovim/neovim-releases/releases/download/$tag/nvim-linux-x86_64.tar.gz"
    tmp="$(mktemp -d)" || return 1
    if ! download "$url" "$tmp/nvim.tar.gz"; then
        err "neovim: download failed ($url)"; rm -rf "$tmp"; return 1
    fi
    if ! tar -xzf "$tmp/nvim.tar.gz" -C "$tmp"; then
        err "neovim: extract failed"; rm -rf "$tmp"; return 1
    fi
    if [ ! -x "$tmp/nvim-linux-x86_64/bin/nvim" ]; then
        err "neovim: unexpected archive layout (no nvim-linux-x86_64/bin/nvim)"
        rm -rf "$tmp"; return 1
    fi
    dir="$OPT_DIR/nvim-linux-x86_64"
    rm -rf "$dir"
    mv "$tmp/nvim-linux-x86_64" "$dir"
    ln -sf "$dir/bin/nvim" "$BIN_DIR/nvim"
    rm -rf "$tmp"
    info "installed nvim ($tag) -> $BIN_DIR/nvim"
}

# --- ripgrep (static musl build) -------------------------------------------
install_ripgrep() {
    if have rg; then
        info "rg already present ($(command -v rg)); skipping"
        return 0
    fi
    info "installing ripgrep (latest stable)"
    local tag base url tmp
    tag="$(latest_tag BurntSushi/ripgrep)" || return 1   # ripgrep tags have no leading 'v'
    base="ripgrep-$tag-x86_64-unknown-linux-musl"
    url="https://github.com/BurntSushi/ripgrep/releases/download/$tag/$base.tar.gz"
    tmp="$(mktemp -d)" || return 1
    if ! download "$url" "$tmp/rg.tar.gz" || ! tar -xzf "$tmp/rg.tar.gz" -C "$tmp"; then
        err "ripgrep: download/extract failed ($url)"; rm -rf "$tmp"; return 1
    fi
    if [ ! -f "$tmp/$base/rg" ]; then
        err "ripgrep: unexpected archive layout (no $base/rg)"; rm -rf "$tmp"; return 1
    fi
    cp -f "$tmp/$base/rg" "$BIN_DIR/rg" && chmod 0755 "$BIN_DIR/rg" || {
        err "ripgrep: install failed"; rm -rf "$tmp"; return 1; }
    rm -rf "$tmp"
    info "installed rg ($tag) -> $BIN_DIR/rg"
}

# --- fzf (single static binary; replaces the old contrib/fzf submodule) ----
install_fzf() {
    if have fzf; then
        info "fzf already present ($(command -v fzf)); skipping"
        return 0
    fi
    info "installing fzf (latest stable)"
    local tag ver url tmp
    tag="$(latest_tag junegunn/fzf)" || return 1
    ver="${tag#v}"                                   # tag vX.Y.Z -> asset uses X.Y.Z
    url="https://github.com/junegunn/fzf/releases/download/$tag/fzf-$ver-linux_amd64.tar.gz"
    tmp="$(mktemp -d)" || return 1
    if ! download "$url" "$tmp/fzf.tar.gz" || ! tar -xzf "$tmp/fzf.tar.gz" -C "$tmp"; then
        err "fzf: download/extract failed ($url)"; rm -rf "$tmp"; return 1
    fi
    if [ ! -f "$tmp/fzf" ]; then
        err "fzf: unexpected archive layout (no fzf binary)"; rm -rf "$tmp"; return 1
    fi
    cp -f "$tmp/fzf" "$BIN_DIR/fzf" && chmod 0755 "$BIN_DIR/fzf" || {
        err "fzf: install failed"; rm -rf "$tmp"; return 1; }
    rm -rf "$tmp"
    info "installed fzf ($tag) -> $BIN_DIR/fzf"
}

# --- zsh (only if absent; romkatv/zsh-bin static zsh 5.8, relocatable) -----
install_zsh() {
    if have zsh; then
        info "zsh already present ($(command -v zsh)); skipping"
        return 0
    fi
    if ! have curl && ! have wget; then
        err "zsh: need curl or wget to fetch zsh-bin"
        return 1
    fi
    info "installing zsh (romkatv/zsh-bin, static zsh 5.8) into $LOCAL_PREFIX"
    local installer="https://raw.githubusercontent.com/romkatv/zsh-bin/master/install"
    # A single -d <dir> makes the installer non-interactive (no dir menu);
    # -e no keeps it from touching /etc/shells. Binary lands at $dir/bin/zsh.
    if have curl; then
        sh -c "$(curl -fsSL "$installer")" -- -e no -d "$LOCAL_PREFIX" || {
            err "zsh: zsh-bin install failed"; return 1; }
    else
        sh -c "$(wget -qO- "$installer")" -- -e no -d "$LOCAL_PREFIX" || {
            err "zsh: zsh-bin install failed"; return 1; }
    fi
    if [ ! -x "$BIN_DIR/zsh" ]; then
        err "zsh: zsh-bin did not produce $BIN_DIR/zsh"
        return 1
    fi
    info "installed zsh (5.8) -> $BIN_DIR/zsh"
}

rc=0
install_neovim  || rc=1
install_ripgrep || rc=1
install_fzf     || rc=1
install_zsh     || rc=1

if [ "$rc" -ne 0 ]; then
    err "one or more tools failed to install"
fi
exit "$rc"
