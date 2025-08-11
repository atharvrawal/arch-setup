#!/bin/bash

echo "========================================"
echo "Setup is Starting..."
echo "========================================"

source ~/arch-setup/post-install/check-status.sh

# System Update & Upgrade
bash ~/arch-setup/post-install/system-update-upgrade.sh
check_status "system-update-upgrade.sh Failed"

# Pacman Packages
bash ~/arch-setup/post-install/pacman-packages.sh
check_status "pacman-packages.sh Failed"

# Yay
bash ~/arch-setup/post-install/yay-install.sh
check_status "yay-install.sh Failed"

# Yay Packages
bash ~/arch-setup/post-install/yay-packages.sh
check_status "yay-packages.sh Failed"

# Flatpak Packages
bash ~/arch-setup/post-install/flatpak-packages.sh
check_status "flatpak-packages.sh Failed"

# Rust
bash ~/arch-setup/post-install/rust-install.sh
check_status "rust-install.sh Failed"

# LazyVim Setup
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
echo "LazyVim Successfully Setup"
echo ""

# Kitty Setup
bash ~/arch-setup/post-install/kitty-setup.sh
check_status "kitty-setup.sh Failed"
