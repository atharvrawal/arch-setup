#!/bin/bash

source ~/arch-setup/post-install/check-status.sh

echo "Installing flatpacks..."
flatpacks=(
  "md.obsidian.Obsidian"
  "com.discordapp.Discord"
  "org.videolan.VLC"
  "com.rafaelmardojai.Blanket"
)
k=0 
total=${#flatpacks[@]}
while [ $k -lt $total ]; do
  pkg=${flatpacks[$k]}
  flatpak install -y --noninteractive flathub "$pkg" >/dev/null 2>&1
  check_status "Failed to install $pkg"
  echo "✅ $pkg installed successfully"
  ((k++))
done
echo "All flatpak packages installed successfully!"
echo ""