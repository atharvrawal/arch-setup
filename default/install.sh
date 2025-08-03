#!/bin/bash

echo "========================================"
echo "Setup is Starting..."
echo "========================================"


# Function to check the exit status of the last command
check_status(){
	if [ $? -ne 0 ]; then
		echo "Error: $1"
		exit 1
	fi
}

echo ""
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
check_status "Failed to set Dark Mode"
echo "Dark Mode Successful"
echo ""

echo "Setting Keybings..."
echo ""
gsettings set org.gnome.desktop.wm.keybindings switch-windows             "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications        "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left   "['<Alt>H']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right  "['<Alt>L']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home           "['<Super>E']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left     "['<Alt><Shift>H']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right    "['<Alt><Shift>L']"
gsettings set org.gnome.desktop.wm.keybindings show-desktop               "['<Super>D']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized           "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings close                      "['<Alt>F4', '<Super>c']"
gsettings set org.gnome.mutter overlay-key                                "['<Super>Tab']"



gsettings set org.gnome.desktop.peripherals.mouse accel-profile           "flat"
gsettings set org.gnome.shell favorite-apps                               "[]"
gsettings set org.gnome.mutter workspaces-only-on-primary                 false


# Create custom binding: Launch Terminal with Alt+T
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ name 'Launch Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ command 'kgx'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/ binding '<Alt>t'

# Create custom binding: Launch Firefox with Alt+F
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-firefox/ name 'Launch Firefox'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-firefox/ command 'firefox'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-firefox/ binding '<Alt>f'

# Register both bindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-terminal/', \
  '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/launch-firefox/']"




echo "Updating & Upgrading Arch..."
sudo pacman -Syy --noconfirm >/dev/null
check_status "Failed to update the package database."
sudo pacman -Syu --noconfirm >/dev/null
check_status "Failed to upgrade the package database."
echo "Successfully Updated & Upgraded"
echo ""

echo "Installing pacman packages..."
pacman_packages=(
	curl
	git
	nvim
	tree
	nmap
	wget
	base-devel
	cmake 
	obs-studio
	flatpak
	net-tools
	nvidia
	nvidia-utils
 	nvidia-prime
	mesa
  	deluge-gtk
)

i=0
total=${#pacman_packages[@]} 

while [ $i -lt $total ]; do
  pkg=${pacman_packages[$i]}
  sudo pacman -S --needed --noconfirm "$pkg" >/dev/null 2>&1
  check_status "Failed to install $pkg"
  echo "✅ $pkg installed successfully"
  ((i++))
done
echo "All pacman packages installed successfully"
echo ""


echo "Installing Yay..."
git clone https://aur.archlinux.org/yay.git >/dev/null 2>&1
check_status "Failed to clone yay repository."
cd yay || { echo "Failed to change directory to yay."; exit 1; }
makepkg -si --noconfirm >/dev/null 2>&1
check_status "Failed to build and install yay."
yay --version
cd ..
sudo rm -rf yay >/dev/null
check_status "Failed to remove the yay package"
echo "Above Version is yay version and is Successfully Installed"
echo ""


yay_packages=(
	"elecwhat-bin"
	"brave-bin"
	"visual-studio-code-bin"
)


j=0
total=${#yay_packages[@]}

while [ $j -lt $total ]; do
  pkg=${yay_packages[$j]}
  yay -S --needed --noconfirm "$pkg" >/dev/null 2>&1
  check_status "Failed to install $pkg"
  echo "✅ $pkg installed successfully"
  ((j++))
done
echo "All yay packages installed succesfully"
echo ""



echo "Installing flatpacks..."
flatpacks=(
  "md.obsidian.Obsidian"
  "com.discordapp.Discord"
  "com.spotify.Client"
  "com.obsproject.Studio"
  "org.kde.kate"
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
