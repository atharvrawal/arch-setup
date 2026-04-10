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
                hyprland hyprlock hypridle hyprpaper jq socat waybar xorg-xwayland wl-clipboard grim slurp xdg-desktop-portal-hyprland \
                alacritty foot fish eza btop qbittorrent wofi\
                flatpak ntfs-3g polkit lxqt-policykit libx11 webkit2gtk brightnessctl unzip \
                libva mesa hostapd qt6ct \
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
mkdir ~/.config/fish
chsh -s /usr/bin/fish
ln -s ~/arch-setup/sway/config.fish ~/.config/fish/config.fish >/dev/null 2>&1

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
ln -s ~/arch-setup/sway/waybar/ws_icons_event.sh ~/.config/waybar/ws_icons_event.sh >/dev/null 2>&1
echo "✅ Waybar symlink successfully setup"

# Hyprland
sudo rm -rf ~/.config/hypr
mkdir -p ~/.config/hypr
ln -s ~/arch-setup/sway/hyprland.conf ~/.config/hypr/hyprland.conf >/dev/null 2>&1
echo "✅ hyprland.conf symlink successful setup"