#!/bin/bash

# ---------- System Upgrade ----------
echo "Updating & Upgrading Arch..."
sudo pacman -Syy --noconfirm >/dev/null
sudo pacman -Syu --noconfirm >/dev/null
echo "✅ Successfully Updated & Upgraded"
echo ""



# ---------- Pacman Packages Install ----------
sudo pacman -S  curl git nvim tree nmap wget base-devel cmake net-tools network-manager-applet \
                thunar gvfs gvfs-mtp gvfs-smb \
                pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber wiremix pavucontrol \
                bluez bluez-utils bluez-obex \
                xorg-server xorg-xinit xorg-xrandr libx11 libxinerama libxft webkit2gtk \
                kitty fish eza rofi btop qbittorrent \
                flatpak ntfs-3g \
                nvidia-dkms nvidia-utils nvidia-prime libva libva-nvidia-driver mesa \
                --needed --noconfirm



# ---------- Rust Setup ----------
read -p "Do you want to install Rust? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    # Check if Rust is already installed
    if command -v rustc >/dev/null 2>&1; then
        echo "Rust is already installed, skipping installation."
    else
        # Rust Setup
        cd ~
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
        echo 'source $HOME/.cargo/env' >> ~/.zshrc
        echo "✅ Rust successfuly installed & added to PATH"
    fi
else
    echo "Skipping Rust installation."
fi



# ---------- Paru Install ----------
echo "Installing Paru..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
paru --version
cd .. 
sudo rm -rf paru >/dev/null
echo "✅ Above Version is yay version and is Successfully Installed"
echo ""



# ---------- Paru Package Install ----------
paru -S visual-studio-code-bin materia-gtk-theme papirus-icon-theme firefox-developer-edition \
        --needed --noconfirm



# ----------- Service Setup ----------
# Github Setup
git config --global user.email "atharvrawal04@gmail.com"
git config --global user.name "Atharv"
echo "✅ Git Email & Name setup Successful"
echo ""

# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
check_status "Failed to enable pipewire or pipewire-pulse or wireplumber"
echo "✅ Audio Server (pipewire) Setup Succesful"
echo ""

# Bluetooth Server Setup (Bluez)
sudo systemctl enable --now bluetooth
check_status "Failed to enable Bluez daemon"
echo "✅ Bluetooth Setup Successful"
echo ""

# Fish Setup
sudo chsh -s /usr/bin/fish
sudo rm ~/.config/fish/config.fish
cat << 'EOF' >> ~/.config/fish/config.fish
set -g fish_greeting ""
alias ls='exa --icons'

# Only run in interactive shells
if status is-interactive
	fastfetch
end

set -U fish_prompt_pwd_dir_length 0

function fish_prompt
	echo ''
	set_color blue
	echo -n (prompt_pwd)

	# Git status
	if test -d .git
		set_color green
		echo -n ' on  ' (git branch --show-current)'*'
	end
	set_color magenta
	echo ''
	echo -n '❯ '
	set_color normal
end
EOF



# ---------- Dark Theme Thunar ----------
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
echo "✅ Dark Theme & Thunar Setup Successfull..."
echo ""



# ---------- DWM Install ----------
# DWM Setup
cd ~/arch-setup/suckless/dmenu
sudo make clean install >/dev/null 2>&1
cd ~/arch-setup/suckless/dwm
sudo make clean install >/dev/null 2>&1
echo "exec /usr/local/bin/dwm" >> ~/.xinitrc
chmod +x ~/.xinitrc
echo "✅ DWM Setup Successful"
