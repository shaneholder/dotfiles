#!/usr/bin/env bash

set -e

###
# Installation of packages, configurations, and dotfiles
###

# DOTFILES repo path
export DOTFILES_LOCATION=$(pwd)

# INSTALL_MODE == 'full' for workstation, else minimal for devcontainers
export INSTALL_MODE="${1}"

# create elevate variable to use sudo if needed
[ "$EUID" -eq 0 ] && elevate='' || elevate='sudo'
export elevate

###
# Install dependencies
###
./bin/dotfiles git


if [ "${INSTALL_MODE}" = 'full' ]; then

fi

echo "🟢 dotfiles setup complete"
