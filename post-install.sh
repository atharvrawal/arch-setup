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
	firefox
    flatpak
    obs-studio
	bat
	exa
	thunar 
	gvfs 
	gvfs-mtp 
	gvfs-smb
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
	"bluetuith"
	"visual-studio-code-bin"
    "albert"
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




# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"

# LY Setup
sudo systemctl enable ly
check_status "Failed to enable ly"

# Rust Setup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# LazyVim Setup
git clone https://github.com/LazyVim/starter ~/.config/nvim 
rm -rf ~/.config/nvim/.git

# Kitty Setup
chsh -s /usr/bin/zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
echo 'source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme'>>~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/syntax-highlighting 
echo 'source ~/.config/zsh/plugins/autosuggestions/zsh-autosuggestions.zsh'>>~/.zshrc
echo 'source ~/.config/zsh/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh'>>~/.zshrc
echo "alias ls='exa --icons'">>~/.zshrc
echo "alias la='ls -la'">>~/.zshrc
echo "alias lh='ls -lh'">>~/.zshrc
echo 'bindkey "^[[1;5D" backward-word      # Ctrl+Left'>>~/.zshrc
echo 'bindkey "^[[1;5C" forward-word       # Ctrl+Right'>>~/.zshrc
echo 'bindkey "^[[3~" delete-char          # Delete'>>~/.zshrc
echo 'bindkey "^H" backward-kill-word      # Ctrl+Backspace'>>~/.zshrc

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

# Albert Setup
echo 'albert &' >> ~/.xinitrc

