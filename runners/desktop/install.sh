#!/bin/bash

set -euo pipefail

echo "Building variant:"
echo "» Base Image Name : ${BASE_IMAGE}"
echo "» Is GNOME        : ${IS_GNOME_VARIANT}"
echo "» Is Open Driver  : ${IS_OPEN_DRIVER}"

wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh

papirus-folders -C yaru

LAYERED_PACKAGES=(
  alacritty
  gparted
  lazygit
  neovim
  # kitty
  # code
)

KDE_PACKAGES=(
  kvantum
  breeze-gtk
  # vinyl-theme
)

GNOME_PACKAGES=(
  gnome-tweaks
)

# Install layered packages
echo "=== Installing common packages ==="
dnf5 install -y "${LAYERED_PACKAGES[@]}"

# Install desktop environment specific packages
echo "=== IS_GNOME_VARIANT: ${IS_GNOME_VARIANT}"

if [[ "${IS_GNOME_VARIANT}" == "true" ]]; then
  echo "=== Installing GNOME packages ==="
  dnf5 install -y "${GNOME_PACKAGES[@]}"

  echo "=== Installing Cosmic Desktop ==="
  dnf5 copr enable -y ryanabx/cosmic-epoch
  dnf5 install -y cosmic-desktop
else
  echo "=== Installing KDE packages ==="
  dnf5 install -y "${KDE_PACKAGES[@]}"
fi
