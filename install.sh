#!/usr/bin/env bash
set -eo pipefail

# Let's get some more verbose output when we're building the container
if [ -n "$BUILDING_DOTFILES_CONTAINER" ]; then
    set -x
fi

###################################################################################################
### Update the dotfiles repo
###################################################################################################
SCRIPT_SOURCE=$(realpath "${BASH_SOURCE[0]}")
DOTFILES_DIR=$(dirname "$SCRIPT_SOURCE")
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"

if [ ! -d "$DOTFILES_GIT_DIR" ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

# Pull the most updated copy
if [ -z "$BUILDING_DOTFILES_CONTAINER" ]; then
    git --git-dir "${DOTFILES_GIT_DIR}" fetch
    git --git-dir "${DOTFILES_GIT_DIR}" rebase --autostash FETCH_HEAD
fi


###################################################################################################
### Installing nix if necessary and sourcing the nix environment
###################################################################################################
NIX_SOURCE_SCRIPT=""
find_nix_install() {
    # Figure out which script to source
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        NIX_SOURCE_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    elif [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
        NIX_SOURCE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

## Install nix if necessary
find_nix_install
if [[ -z "${NIX_SOURCE_SCRIPT}" ]]; then
    curl -L https://nixos.org/nix/install | sh
    find_nix_install
fi

. $NIX_SOURCE_SCRIPT

# Copy some configs over
mkdir -p "$HOME/.config/home-manager"
mkdir -p "$HOME/.config/nix"

# Ensure the configs exist
ln -sf "${DOTFILES_DIR}/modules/home.nix" "${HOME}/.config/home-manager/home.nix"

# Which nix.conf to link depends on whether a daemon is in play. Restricted settings (substituters,
# trusted-public-keys) are honored from a user-level config only on single-user installs; on a
# daemon install they have to live in /etc/nix/nix.conf instead, and naming them here would just
# warn on every nix invocation. See ensure_nix_cache_configured below.
if [ -n "$CODER" ]; then
	ln -sf "${DOTFILES_DIR}/configs/coder-nix.conf" "${HOME}/.config/nix/nix.conf"
elif [ -S /nix/var/nix/daemon-socket/socket ]; then
	ln -sf "${DOTFILES_DIR}/configs/nix-daemon.conf" "${HOME}/.config/nix/nix.conf"
else
	ln -sf "${DOTFILES_DIR}/configs/nix.conf" "${HOME}/.config/nix/nix.conf"
fi

###################################################################################################
### Make the binary cache available to the nix daemon
###################################################################################################
# `substituters` and `trusted-public-keys` are restricted settings, so a multi-user daemon ignores
# them from a user-level nix.conf: the attic cache gets silently dropped and everything rebuilds
# from source. Setting them in /etc/nix/nix.conf fixes that for every user on the machine, without
# granting anyone trusted-user rights -- which nix documents as "essentially equivalent to giving
# that user root access to the system".
SYSTEM_NIX_CONF="/etc/nix/nix.conf"
CACHE_BLOCK_START="# >>> managed by dotfiles: binary cache >>>"
CACHE_BLOCK_END="# <<< managed by dotfiles: binary cache <<<"

# configs/nix.conf remains the single source of truth for the cache URL and its public key.
desired_cache_block() {
    echo "$CACHE_BLOCK_START"
    grep -E '^[[:space:]]*extra-(substituters|trusted-public-keys)[[:space:]]*=' \
        "${DOTFILES_DIR}/configs/nix.conf"
    echo "$CACHE_BLOCK_END"
}

current_cache_block() {
    [ -r "$SYSTEM_NIX_CONF" ] || return 0
    awk -v s="$CACHE_BLOCK_START" -v e="$CACHE_BLOCK_END" \
        '$0==s{f=1} f{print} $0==e{f=0}' "$SYSTEM_NIX_CONF"
}

# Every step returns non-zero rather than aborting, so the caller can degrade to a warning.
apply_cache_block() {
    local tmp stale
    # Migration: an earlier version of this script granted trusted-user rights instead. Drop that
    # line if it is exactly what we wrote, now that the cache no longer needs it.
    stale="trusted-users = root $(id -un)"

    sudo -v || return 1
    tmp=$(mktemp) || return 1

    {
        awk -v s="$CACHE_BLOCK_START" -v e="$CACHE_BLOCK_END" -v stale="$stale" \
            '$0==s{f=1} $0==stale{next} !f{print} $0==e{f=0}' "$SYSTEM_NIX_CONF" 2>/dev/null
        desired_cache_block
    } > "$tmp" || { rm -f "$tmp"; return 1; }

    # cp rather than mv, so the file keeps its existing root ownership and mode.
    sudo cp "$tmp" "$SYSTEM_NIX_CONF" || { rm -f "$tmp"; return 1; }
    rm -f "$tmp"

    # The daemon only re-reads nix.conf on restart.
    if [[ "$(uname -s)" == "Darwin" ]]; then
        sudo launchctl kickstart -k system/org.nixos.nix-daemon || return 1
    elif command -v systemctl > /dev/null; then
        sudo systemctl restart nix-daemon || return 1
    fi
}

ensure_nix_cache_configured() {
    # Single-user installs read the cache straight out of configs/nix.conf; the container build has
    # neither a daemon nor sudo; coder workspaces deliberately configure no cache at all.
    [ -S /nix/var/nix/daemon-socket/socket ] || return 0
    [ -z "$BUILDING_DOTFILES_CONTAINER" ] || return 0
    [ -z "$CODER" ] || return 0

    # Already in place: nothing to do, and notably no sudo prompt.
    if [ "$(current_cache_block)" = "$(desired_cache_block)" ]; then
        return 0
    fi

    echo "Configuring the binary cache in ${SYSTEM_NIX_CONF} (requires sudo)..."

    # The cache is an optimization; failing to configure it must never abort the install.
    if apply_cache_block; then
        echo "Binary cache configured for every user on this machine."
    else
        echo "WARNING: could not configure the binary cache in ${SYSTEM_NIX_CONF}." >&2
        echo "WARNING: continuing without it; builds may be slow." >&2
    fi
}

ensure_nix_cache_configured

USE_NEW_NIX=1 nix run .#setupDotfiles
