#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh

echo "Updating & Upgrading Arch..."
sudo pacman -Syy --noconfirm >/dev/null
check_status "Failed to update the package database."
sudo pacman -Syu --noconfirm >/dev/null
check_status "Failed to upgrade the package database."
echo "✅ Successfully Updated & Upgraded"
echo ""