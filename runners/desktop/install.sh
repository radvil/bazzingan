#!/bin/bash

set -ouex pipefail

echo "Building variant:"
echo "» Base Image Name : ${BASE_IMAGE_NAME}"
echo "» Is GNOME        : ${IS_GNOME_VARIANT}"
echo "» Is Open Driver  : ${IS_OPEN_DRIVER}"

wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh

papirus-folders -C yaru

KDE_PACKAGES=(
  kvantum
  breeze-gtk
)

GNOME_PACKAGES=(
  gnome-tweaks
)

LAYERED_PACKAGES=(
  vinyl-theme
  alacritty
  gparted
  lazygit
  neovim
  kitty
  code
)

# Install layered packages
echo "=== Installing common packages ==="
dnf5 install -y "${LAYERED_PACKAGES[@]}"

# Install desktop environment specific packages
if [[ "${IS_GNOME_VARIANT}" == "1" ]]; then
  echo "=== Installing GNOME packages ==="
  dnf5 install -y "${GNOME_PACKAGES[@]}"
else
  echo "=== Installing KDE packages ==="
  dnf5 install -y "${KDE_PACKAGES[@]}"
fi

# Configure desktop environment
if [[ "${IS_GNOME_VARIANT}" == "1" ]]; then
  echo "=== Configuring GNOME settings ==="
  dnf5 copr enable -y ryanabx/cosmic-epoch
  dnf5 install -y cosmic-desktop
fi
