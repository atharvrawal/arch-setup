#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh

# LY Setup
sudo systemctl enable ly
check_status "Failed to enable ly"
echo "✅ Ly Setup Successful"
echo ""

# Github Setup
git config --global user.email "atharvrawal04@gmail.com"
git config --global user.name "Atharv"
echo "✅ Git Email & Name setup Successful"
echo ""