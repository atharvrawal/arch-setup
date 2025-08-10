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

# System Update & Upgrade
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
 	pipewire 
  	pipewire-audio 
  	pipewire-alsa 
  	pipewire-pulse 
  	pipewire-jack
  	wireplumber
	xorg-server
	xorg-xinit
	xorg-xrandr
	libx11
	libxinerama
	libxft
	webkit2gtk
	kitty
	zsh
	ly
	exa
	rofi
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



if command -v yay >/dev/null 2>&1; then
    echo "Yay is already installed. Skipping installation."
    yay --version
    echo ""
else
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
fi
yay_packages=(
	"ttf-firacode-nerd"
	"materia-gtk-theme"
	"papirus-icon-theme"
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





# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"

# LY Setup
sudo systemctl enable ly
check_status "Failed to enable ly"

# Dark Theme Setup
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Materia-dark
gtk-icon-theme=Papirus-Dark
gtk-application-prefer-dark-theme=true
EOF

mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Materia-dark
gtk-icon-theme=Papirus-Dark
gtk-application-prefer-dark-theme=true
EOF

# Thunar Setup (xdg-open)
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/Thunar.desktop <<EOF
[Desktop Entry]
Name=Thunar
Exec=thunar %f
Icon=system-file-manager
Terminal=false
Type=Application
Categories=Utility;Core;GTK;
MimeType=inode/directory;
EOF
update-desktop-database ~/.local/share/applications

# DWM Setup
cd suckless
cd dmenu
sudo make clean install
cd .. 
cd dwm
sudo make clean install
cd ../..
echo "exec dwm" >> ~/.xinitrc
chmod +x ~/.xinitrc

