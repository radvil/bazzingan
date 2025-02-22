#!/bin/bash

set -ouex pipefail

# Apply IP Forwarding before installing Docker to prevent messing with LXC networking

sysctl -p

dnf5 copr enable -y foopsss/shell-color-scripts

# Install base packges

core_packages=(
  "NetworkManager-tui"
  "podman"
  "nodejs"
  "tmux"
  "wget"
  "git"
  "gh"
  "jq"
)

utility_packages=(
  "shell-color-scripts"
  "git-delta"
  "fastfetch"
  "starship"
  "ripgrep"
  "fish"
  "hub"
  "zsh"
  "eza"
  "fzf"
  "bat"
  "fd"
)

packages=(
  "${core_packages[@]}"
  "${utility_packages[@]}"
)

dnf5 install -y "${packages[@]}"
