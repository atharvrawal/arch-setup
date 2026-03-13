#!/bin/bash

# ---------- System Upgrade ----------
echo "Updating & Upgrading Arch..."
sudo pacman -Syy --noconfirm >/dev/null
sudo pacman -Syu --noconfirm >/dev/null
echo "✅ Successfully Updated & Upgraded"
echo ""



# ---------- Pacman Packages Install ----------
sudo pacman -S  curl git nvim tree nmap wget base-devel cmake net-tools iw network-manager-applet fastfetch jdk-openjdk \
                thunar gvfs gvfs-mtp gvfs-smb \
                pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol pamixer pulsemixer\
                bluez bluez-utils bluez-obex blueman \
                sway swaybg swaylock swayidle jq waybar xorg-xwayland wl-clipboard grim slurp xdg-desktop-portal-wlr \
                alacritty foot fish eza btop qbittorrent\
                flatpak ntfs-3g polkit lxqt-policykit libx11 webkit2gtk brightnessctl unzip \
                libva mesa hostapd qt6ct greetd \
                sof-firmware alsa-firmware \
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
        echo 'source $HOME/.cargo/env' >> ~/.config/fish/config.fish
        echo "✅ Rust successfuly installed & added to PATH"
    fi
else
    echo "Skipping Rust installation."
fi



# ---------- Paru Install ----------
echo "Installing Paru..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
paru --version
cd .. 
sudo rm -rf paru >/dev/null
echo "✅ Above Version is paru version and is Successfully Installed"
echo ""



# ---------- Paru Package Install ----------
paru -S visual-studio-code-bin colloid-gtk-theme-git colloid-icon-theme-git \
        firefox-developer-edition ttf-hack-nerd power-profiles-daemon nmgui-bin\
        --needed --noconfirm



# ----------- Service Setup ----------
# Network Manager Setup
sudo systemctl enable --now NetworkManager
echo "✅ Network Manager Setup Successful"
echo ""

# Github Setup
git config --global user.email "atharvrawal04@gmail.com"
git config --global user.name "Atharv"
echo "✅ Git Email & Name setup Successful"
echo ""

# Audio Server Setup (Pipewire)
systemctl --user enable pipewire pipewire-pulse wireplumber
echo "✅ Audio Server (pipewire) Setup Succesful"
echo ""

# Bluetooth Server Setup (Bluez)
sudo systemctl enable --now bluetooth
echo "✅ Bluetooth Setup Successful"
echo "" 
# Fish Setup
chsh -s /usr/bin/fish
mkdir ~/.config/fish
cat << 'EOF' >> ~/.config/fish/config.fish
set -g fish_greeting ""
alias ls='eza --icons'
alias la='eza -la --icons'
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

mkdir -p ~/.config/foot
echo "font=Hack Nerd Font:size=11" >> ~/.config/foot/foot.ini
echo "[colors-dark]" >> ~/.config/foot/foot.ini
echo "alpha=0.7" >> ~/.config/foot/foot.ini




# ---------- Dark Theme Thunar ----------
gsettings set org.gnome.desktop.interface gtk-theme Colloid-Dark
gsettings set org.gnome.desktop.interface icon-theme Colloid-dark

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

# Waybar
sudo rm -rf ~/.config/waybar
mkdir -p ~/.config/waybar
ln -s ~/arch-setup/sway/waybar/config.jsonc ~/.config/waybar/config.jsonc >/dev/null 2>&1
ln -s ~/arch-setup/sway/waybar/style.css ~/.config/waybar/style.css >/dev/null 2>&1
ln -s ~/arch-setup/sway/waybar/toggle-waybar.sh ~/.config/waybar/toggle-waybar.sh >/dev/null 2>&1
echo "✅ Waybar symlink successfully setup"

# greetd
sudo rm /etc/issue
sudo touch /etc/issue
sudo rm /etc/greetd/config.toml
sudo tee /etc/greetd/config.toml > /dev/null <<'EOF'
[terminal]
vt = 1

[default_session]
command = "agreety --cmd sway"
user = "greeter"
EOF

# Sway config
mkdir -p ~/.sway
ln -s ~/arch-setup/sway/config ~/.sway/config
echo "✅ Sway Setup Successful"
