#!/bin/bash
read -p "Do you want to install DWM? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    source ~/arch-setup/complete-install/check-status.sh

    # DWM Setup
    cd ~/arch-setup/suckless/dmenu
    sudo make clean install >/dev/null 2>&1
    check_status "Failed to install DMENU"
    cd ~/arch-setup/suckless/dwm
    sudo make clean install >/dev/null 2>&1
    check_status "Failed to install DWM"
    echo "exec dwm" >> ~/.xinitrc
    chmod +x ~/.xinitrc
    echo "✅ DWM Setup Successful"
else
    echo "Skipping DWM installation."
fi