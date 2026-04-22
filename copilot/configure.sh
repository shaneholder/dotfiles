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
  ["${HOME}/.agents"]="${DOTFILES_LOCATION}/copilot/agents"
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

# Install MCP servers
MCP_INSTALLED=$(copilot mcp list 2>/dev/null || true)
if ! echo "${MCP_INSTALLED}" | grep -q "playwright"; then
  echo "Installing Playwright MCP server..."
  copilot mcp add playwright -- npx @playwright/mcp@latest
else
  echo "Skipping MCP playwright: already installed"
fi

# Install plugins listed in plugins.txt
PLUGINS_FILE="${DOTFILES_LOCATION}/copilot/plugins.txt"
if [[ -f "${PLUGINS_FILE}" ]]; then
  INSTALLED=$(copilot plugin list 2>/dev/null || true)
  while IFS= read -r plugin || [[ -n "${plugin}" ]]; do
    [[ -z "${plugin}" || "${plugin}" == \#* ]] && continue
    plugin_name="${plugin##*/}"
    if echo "${INSTALLED}" | grep -q "• ${plugin_name}"; then
      echo "Skipping plugin ${plugin}: already installed"
    else
      echo "Installing plugin ${plugin}..."
      copilot plugin install "${plugin}"
    fi
  done < "${PLUGINS_FILE}"
fi