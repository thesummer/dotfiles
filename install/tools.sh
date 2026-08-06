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
err() { printf 'tools.sh: error: %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

# --- bootstrap downloader (curl via apt-get if neither curl nor wget) -------
# Every installer below needs curl or wget. If neither exists, try to install
# curl with apt-get (available on Debian/Ubuntu-based devcontainer images;
# apt-get has its own HTTP transport, so no downloader is needed for this).
# Fails loudly if apt-get is unavailable or the install does not succeed
# (e.g. not running as root, no network).
ensure_downloader() {
    if have curl || have wget; then
        return 0
    fi
    if ! have apt-get; then
        err "neither curl nor wget found, and apt-get is unavailable to install curl"
        return 1
    fi
    info "neither curl nor wget found; installing curl via apt-get"
    if ! apt-get update; then
        err "curl: apt-get update failed"
        return 1
    fi
    if ! DEBIAN_FRONTEND=noninteractive apt-get install -y curl; then
        err "curl: apt-get install curl failed"
        return 1
    fi
    if ! have curl; then
        err "curl: not on PATH even after apt-get install succeeded"
        return 1
    fi
    info "installed curl ($(command -v curl))"
}

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
        effective="$(wget -S --max-redirect=10 --spider -- "$url" 2>&1 |
            awk '/^[[:space:]]*Location:/{print $2}' | tail -n1)" || effective=""
    else
        err "need curl or wget to resolve latest release for $repo"
        return 1
    fi
    tag="${effective##*/tag/}" # strip up to and including "/tag/"
    tag="${tag%%[?#]*}"        # drop any query/fragment
    if [ -z "$tag" ] || [ "$tag" = "$effective" ]; then
        err "could not resolve latest release tag for $repo (offline or rate-limited?)"
        return 1
    fi
    printf '%s\n' "$tag"
}

# --- resolve the latest Node.js LTS version from nodejs.org ------------------
# nodejs.org is not GitHub, so the redirect trick above does not apply. The
# dist index lists every version newest-first with an "lts" column that holds a
# codename for LTS lines and "-" otherwise; the first LTS-marked row is the
# current LTS (the same signal nvm/fnm use). Prints e.g. "v22.21.0". Fails
# loudly if the index cannot be fetched or no LTS row is found.
node_latest_lts_version() {
    local url="https://nodejs.org/dist/index.tab" tmp ver
    tmp="$(mktemp)" || return 1
    if ! download "$url" "$tmp"; then
        err "node: could not fetch $url (offline?)"
        rm -f "$tmp"
        return 1
    fi
    # Locate the "lts" column by name (robust to column re-ordering), then print
    # the version of the first data row whose lts field is set (not "-").
    ver="$(awk -F'\t' '
        NR==1 { for (i=1;i<=NF;i++) if ($i=="lts") c=i; next }
        c && $c!="" && $c!="-" { print $1; exit }
    ' "$tmp")"
    rm -f "$tmp"
    if [ -z "$ver" ]; then
        err "node: could not determine latest LTS from index.tab"
        return 1
    fi
    printf '%s\n' "$ver"
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
        err "neovim: download failed ($url)"
        rm -rf "$tmp"
        return 1
    fi
    if ! tar -xzf "$tmp/nvim.tar.gz" -C "$tmp"; then
        err "neovim: extract failed"
        rm -rf "$tmp"
        return 1
    fi
    if [ ! -x "$tmp/nvim-linux-x86_64/bin/nvim" ]; then
        err "neovim: unexpected archive layout (no nvim-linux-x86_64/bin/nvim)"
        rm -rf "$tmp"
        return 1
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
    tag="$(latest_tag BurntSushi/ripgrep)" || return 1 # ripgrep tags have no leading 'v'
    base="ripgrep-$tag-x86_64-unknown-linux-musl"
    url="https://github.com/BurntSushi/ripgrep/releases/download/$tag/$base.tar.gz"
    tmp="$(mktemp -d)" || return 1
    if ! download "$url" "$tmp/rg.tar.gz" || ! tar -xzf "$tmp/rg.tar.gz" -C "$tmp"; then
        err "ripgrep: download/extract failed ($url)"
        rm -rf "$tmp"
        return 1
    fi
    if [ ! -f "$tmp/$base/rg" ]; then
        err "ripgrep: unexpected archive layout (no $base/rg)"
        rm -rf "$tmp"
        return 1
    fi
    cp -f "$tmp/$base/rg" "$BIN_DIR/rg" && chmod 0755 "$BIN_DIR/rg" || {
        err "ripgrep: install failed"
        rm -rf "$tmp"
        return 1
    }
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
    ver="${tag#v}" # tag vX.Y.Z -> asset uses X.Y.Z
    url="https://github.com/junegunn/fzf/releases/download/$tag/fzf-$ver-linux_amd64.tar.gz"
    tmp="$(mktemp -d)" || return 1
    if ! download "$url" "$tmp/fzf.tar.gz" || ! tar -xzf "$tmp/fzf.tar.gz" -C "$tmp"; then
        err "fzf: download/extract failed ($url)"
        rm -rf "$tmp"
        return 1
    fi
    if [ ! -f "$tmp/fzf" ]; then
        err "fzf: unexpected archive layout (no fzf binary)"
        rm -rf "$tmp"
        return 1
    fi
    cp -f "$tmp/fzf" "$BIN_DIR/fzf" && chmod 0755 "$BIN_DIR/fzf" || {
        err "fzf: install failed"
        rm -rf "$tmp"
        return 1
    }
    rm -rf "$tmp"
    info "installed fzf ($tag) -> $BIN_DIR/fzf"
}

# --- Node.js + npm (latest LTS; needed for nvim-treesitter) -----------------
# npm is not distributed on its own; it ships bundled in the Node.js tarball
# (node, npm, npx all under bin/). We key the skip check on npm since that is
# the tool being requested. Uses the standard linux-x64 build, which requires
# glibc >= 2.28 (fine on Ubuntu 20.04+; would not run on older bases).
install_node() {
    if have npm; then
        info "npm already present ($(command -v npm)); skipping Node.js install"
        return 0
    fi
    info "installing Node.js (latest LTS, bundles npm)"
    local ver base url tmp dir
    ver="$(node_latest_lts_version)" || return 1
    base="node-$ver-linux-x64"
    url="https://nodejs.org/dist/$ver/$base.tar.gz" # .tar.gz avoids needing xz
    tmp="$(mktemp -d)" || return 1
    if ! download "$url" "$tmp/node.tar.gz" || ! tar -xzf "$tmp/node.tar.gz" -C "$tmp"; then
        err "node: download/extract failed ($url)"
        rm -rf "$tmp"
        return 1
    fi
    if [ ! -x "$tmp/$base/bin/node" ] || [ ! -e "$tmp/$base/bin/npm" ]; then
        err "node: unexpected archive layout (no $base/bin/node or npm)"
        rm -rf "$tmp"
        return 1
    fi
    dir="$OPT_DIR/$base"
    rm -rf "$dir"
    mv "$tmp/$base" "$dir"
    # Symlink the whole toolchain; npm/npx resolve node via ~/.local/bin on PATH.
    ln -sf "$dir/bin/node" "$BIN_DIR/node"
    ln -sf "$dir/bin/npm" "$BIN_DIR/npm"
    ln -sf "$dir/bin/npx" "$BIN_DIR/npx"
    rm -rf "$tmp"
    info "installed Node.js ($ver, bundled npm) -> $BIN_DIR/{node,npm,npx}"
}

# --- opencode (static via npm) -------------------------------------------
install_opencode() {
    if have opencode; then
        info "opencode already present ($(command -v rg)); skipping"
        return 0
    fi
    info "installing opencode (latest stable)"
    if ! npm i -g opencode-ai@latest --allow-scripts=opencode-ai; then
        err "opencode: Installation failed"
        return 1
    fi
    ln -sf "$(npm prefix -g)/bin/opencode" "$BIN_DIR/opencode"
    info "installed opencode -> $BIN_DIR/opencode"
}

# --- pi (static via npm) -------------------------------------------
install_pi() {
    if have pi; then
        info "pi already present ($(command -v rg)); skipping"
        return 0
    fi
    info "installing pi (latest stable)"
    if ! npm install -g --ignore-scripts @earendil-works/pi-coding-agent; then
        err "pi: Installation failed"
        return 1
    fi
    ln -sf "$(npm prefix -g)/bin/pi" "$BIN_DIR/pi"
    info "installed pi -> $BIN_DIR/pi"
}

# --- devpod (single binary; installs to ~/.local/bin) ----------------------
install_devpod() {
    if have devpod; then
        info "devpod already present ($(command -v devpod)); skipping"
        return 0
    fi
    # Skip if running inside a container
    if [ -f /run/.containerenv ] || [ -f /.dockerenv ]; then
        info "running inside a container; skipping devpod installation"
        return 0
    fi
    info "installing devpod (latest stable)"
    local url tmp
    url="https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
    tmp="$(mktemp)" || return 1
    if ! download "$url" "$tmp/devpod"; then
        err "devpod: download failed ($url)"
        rm -f "$tmp"
        return 1
    fi
    cp -f "$tmp/devpod" "$BIN_DIR/devpod" && chmod 0755 "$BIN_DIR/devpod" || {
        err "devpod: install failed"
        rm -f "$tmp"
        return 1
    }
    rm -f "$tmp"
    info "installed devpod -> $BIN_DIR/devpod"
}

# --- herdr (Rust CLI tool installer) ---------------------------------------
install_herdr() {
    if have herdr; then
        info "herdr already present ($(command -v herdr)); skipping"
        return 0
    fi
    info "installing herdr (latest stable) into $BIN_DIR"
    if ! HERDR_INSTALL_DIR="$BIN_DIR" curl -fsSL https://herdr.dev/install.sh | sh; then
        err "herdr: installation failed"
        return 1
    fi
    if [ ! -x "$BIN_DIR/herdr" ]; then
        err "herdr: $BIN_DIR/herdr not found after install"
        return 1
    fi
    info "installed herdr -> $BIN_DIR/herdr"
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
            err "zsh: zsh-bin install failed"
            return 1
        }
    else
        sh -c "$(wget -qO- "$installer")" -- -e no -d "$LOCAL_PREFIX" || {
            err "zsh: zsh-bin install failed"
            return 1
        }
    fi
    if [ ! -x "$BIN_DIR/zsh" ]; then
        err "zsh: zsh-bin did not produce $BIN_DIR/zsh"
        return 1
    fi
    info "installed zsh (5.8) -> $BIN_DIR/zsh"
}

# Without a downloader every installer below fails; abort early with one
# clear error instead of five confusing ones.
if ! ensure_downloader; then
    err "no downloader available; cannot install tools"
    exit 1
fi

rc=0
install_devpod || rc=1
install_neovim || rc=1
install_ripgrep || rc=1
install_fzf || rc=1
install_node || rc=1
# install_opencode || rc=1
install_pi || rc=1
install_herdr || rc=1
install_zsh || rc=1

if [ "$rc" -ne 0 ]; then
    err "one or more tools failed to install"
fi
exit "$rc"
