#!/usr/bin/env bash

# Resolve the repo root from this script's location (install/ -> repo root),
# unless the caller already exported REPO_DIR. Do not hardcode ~/.dotfiles.
: "${REPO_DIR:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
DOTFILES="$REPO_DIR"

# Check if running in a container
is_container=false
if [ -f /run/.containerenv ] || [ -f /.dockerenv ]; then
    is_container=true
fi

echo -e "\\nCreating symlinks"
echo "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename "$file" '.symlink' )"
    if [ -e "$target" ]; then
        if [ "$is_container" = true ]; then
            echo "Running in container - backing up ~${target#$HOME} to ~${target#$HOME}.bak"
            mv "$target" "${target}.bak"
        else
            echo "~${target#$HOME} already exists... Skipping."
            continue
        fi
    fi
    echo "Creating symlink for $file"
    ln -s "$file" "$target"
done

echo -e "\\n\\ninstalling to ~/.config"
echo "=============================="
if [ ! -d "$HOME/.config" ]; then
    echo "Creating ~/.config"
    mkdir -p "$HOME/.config"
fi

config_files=$( find "$DOTFILES/config" -maxdepth 1 2>/dev/null )
for config in $config_files; do
    target="$HOME/.config/$( basename "$config" )"
    if [ -e "$target" ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $config"
        ln -s "$config" "$target"
    fi
done

# create vim symlinks
# As I have moved off of vim as my full time editor in favor of neovim,
# I feel it doesn't make sense to leave my vimrc intact in the dotfiles repo
# as it is not really being actively maintained. However, I would still
# like to configure vim, so lets symlink ~/.vimrc and ~/.vim over to their
# neovim equivalent.

# echo -e "\\n\\nCreating vim symlinks"
# echo "=============================="
# VIMFILES=( "$HOME/.vim:$DOTFILES/config/nvim"
#         "$HOME/.vimrc:$DOTFILES/config/nvim/init.vim" )
# 
# for file in "${VIMFILES[@]}"; do
#     KEY=${file%%:*}
#     VALUE=${file#*:}
#     if [ -e "${KEY}" ]; then
#         echo "${KEY} already exists... skipping."
#     else
#         echo "Creating symlink for $KEY"
#         ln -s "${VALUE}" "${KEY}"
#     fi
# done
