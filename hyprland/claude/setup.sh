#!/bin/bash
mkdir -p ~/.config/claude
rm -rf ~/.local/share/applications/04-Claude.desktop
rm -rf ~/.local/share/applications/124-Claude.desktop
rm -rf ~/.local/share/applications/pes.desktop
rm -rf ~/.local/share/applications/4yeartransform.desktop
rm -rf ~/.local/share/applications/portmux.desktop

cp ~/arch-setup/hyprland/claude/04-Claude.desktop ~/.local/share/applications/04-Claude.desktop
chmod +x ~/.local/share/applications/04-Claude.desktop

cp ~/arch-setup/hyprland/claude/124-Claude.desktop ~/.local/share/applications/124-Claude.desktop
chmod +x ~/.local/share/applications/124-Claude.desktop

cp ~/arch-setup/hyprland/claude/pes.desktop ~/.local/share/applications/pes.desktop
chmod +x ~/.local/share/applications/pes.desktop

cp ~/arch-setup/hyprland/claude/4yeartransform.desktop ~/.local/share/applications/4yeartransform.desktop
chmod +x ~/.local/share/applications/4yeartransform.desktop

cp ~/arch-setup/hyprland/claude/portmux.desktop ~/.local/share/applications/portmux.desktop
chmod +x ~/.local/share/applications/portmux.desktop

echo "Claude desktop entries have been set up successfully."
