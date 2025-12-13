#!/usr/bin/env bash

set -e

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
~/.local/bin/oh-my-posh font install meslo
eval "$(~/.local/bin/oh-my-posh init zsh --config cloud-native-azure)"
