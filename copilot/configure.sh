#!/usr/bin/env bash

set -e

FORCE=false
[[ "${1}" == "--force" ]] && FORCE=true

# VS Code user prompts directory (works in both WSL and devcontainers)
declare -A LINKS=(
  ["${HOME}/.vscode-server/data/User/prompts"]="${DOTFILES_LOCATION}/copilot/prompts"
  ["${HOME}/.copilot/skills"]="${DOTFILES_LOCATION}/copilot/skills"
  ["${HOME}/.copilot/agents"]="${DOTFILES_LOCATION}/copilot/agents"
  ["${HOME}/.copilot/hooks"]="${DOTFILES_LOCATION}/copilot/hooks"
)

for target in "${!LINKS[@]}"; do
  src="${LINKS[$target]}"
  if [[ -L "${target}" ]]; then
    "${FORCE}" && rm "${target}" || { echo "Skipping ${target}: already a symlink (use --force to replace)"; continue; }
  elif [[ -e "${target}" ]]; then
    echo "Skipping ${target}: exists and is not a symlink"
    continue
  fi
  mkdir -p "$(dirname "${target}")"
  ln -snT "${src}" "${target}"
done