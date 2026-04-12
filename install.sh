#!/usr/bin/env bash

set -e

###
# Installation of packages, configurations, and dotfiles
###

# DOTFILES repo path
export DOTFILES_LOCATION=$(pwd)

# Parse args: optional --force flag and optional INSTALL_MODE
FORCE_FLAG=""
export INSTALL_MODE=""
for arg in "$@"; do
  [[ "${arg}" == "--force" ]] && FORCE_FLAG="--force" || INSTALL_MODE="${arg}"
done

# create elevate variable to use sudo if needed
[ "$EUID" -eq 0 ] && elevate='' || elevate='sudo'
export elevate

###
# Install dependencies
###
./bin/dotfiles git ${FORCE_FLAG}
./bin/dotfiles omz ${FORCE_FLAG}
./bin/dotfiles zsh ${FORCE_FLAG}
./bin/dotfiles copilot ${FORCE_FLAG}


if [ "${INSTALL_MODE}" = 'full' ]; then
  echo "Installing full dotfiles"
fi

echo "🟢 dotfiles setup complete"
