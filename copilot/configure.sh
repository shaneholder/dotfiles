#!/usr/bin/env bash

set -e

# VS Code user prompts directory (works in both WSL and devcontainers)
PROMPTS_DIR="${HOME}/.vscode-server/data/User/prompts"
SKILLS_DIR="${HOME}/.copilot/skills"

mkdir -p "${PROMPTS_DIR}"
mkdir -p "${SKILLS_DIR}"

# Symlink all prompt and agent files
for file in "${DOTFILES_LOCATION}"/copilot/prompts/*.{prompt,agent}.md; do
  [ -f "${file}" ] || continue
  ln -sf "${file}" "${PROMPTS_DIR}/$(basename "${file}")"
done

# Symlink all skill directories
for dir in "${DOTFILES_LOCATION}"/copilot/skills/*/; do
  [ -d "${dir}" ] || continue
  skill_name="$(basename "${dir}")"
  target="${SKILLS_DIR}/${skill_name}"
  # Remove existing non-symlink directory before linking
  if [ -d "${target}" ] && [ ! -L "${target}" ]; then
    rm -rf "${target}"
  fi
  ln -sfnT "${dir}" "${target}"
done
