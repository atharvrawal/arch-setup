#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh

sudo pacman -S --needed --noconfirm \
    bluez \
    bluez-utils \
    bluez-obex >/dev/null 2>&1
check_status "Failed to install Bluez and related packages"
echo "✅ Bluez and related packages installed successfully"
echo ""

# Bluetooth Server Setup (Bluez)
sudo systemctl enable --now bluetooth
check_status "Failed to enable Bluez daemon"
echo "✅ Bluetooth Setup Successful"
echo ""
