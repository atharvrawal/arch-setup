#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh

sudo pacman -S --needed --noconfirm \
 	pipewire \
  	pipewire-audio \ 
  	pipewire-alsa \
  	pipewire-pulse \
  	pipewire-jack \
  	wireplumber \
	wiremix \
	pavucontrol >/dev/null 2>&1
check_status "Failed to install Pipewire or its components"
echo "✅ Pipewire and its components installed successfully"
echo ""

# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"
echo "✅ Audio Server (pipewire) Setup Succesful"
echo ""

# Optional: Disable PulseAudio if previously installed
if systemctl --user is-active --quiet pulseaudio; then
    systemctl --user disable --now pulseaudio
    check_status "Failed to disable PulseAudio"
    echo "✅ PulseAudio disabled successfully"
    echo ""
fi
