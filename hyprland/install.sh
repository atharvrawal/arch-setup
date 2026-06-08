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
                bluez bluez-utils bluez-obex blueman bluetui \
                hyprland hyprlock hypridle hyprpaper jq socat waybar xorg-xwayland wl-clipboard grim slurp xdg-desktop-portal-hyprland quickshell \
                alacritty foot fish eza btop qbittorrent wofi dunst qt6-positioning \
                flatpak ntfs-3g polkit lxqt-policykit libx11 webkit2gtk brightnessctl unzip fontforge \
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
paru -S visual-studio-code-bin flat-remix-gtk flat-remix \
        firefox-developer-edition ttf-hack-nerd power-profiles-daemon brave-origin-nightly-bin\
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
ln -s ~/arch-setup/hyprland/config.fish ~/.config/fish/config.fish >/dev/null

mkdir -p ~/.config/foot
echo "font=Hack Nerd Font:size=11" >> ~/.config/foot/foot.ini
echo "[colors-dark]" >> ~/.config/foot/foot.ini
echo "alpha=0.7" >> ~/.config/foot/foot.ini



# ---------- Dark Theme Thunar ----------
gsettings set org.gnome.desktop.interface gtk-theme Flat-Remix-GTK-Grey-Darkest-Solid
gsettings set org.gnome.desktop.interface icon-theme Flat-Remix-Black-Dark

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

rm -rf ~/.config/Thunar
ln -s ~/arch-setup/hyprland/Thunar ~/.config/Thunar >/dev/null
echo "✅ Dark Theme & Thunar Setup Successfull..."
echo ""

# Poweroff Setup
sudo sed -i '/HandlePowerKey/d' /etc/systemd/logind.conf
echo 'HandlePowerKey=ignore' | sudo tee -a /etc/systemd/logind.conf
sudo systemctl restart systemd-logind
echo "✅ Poweroff Button Setup Successful"
echo ""

# Waybar
rm -rf ~/.config/waybar
mkdir -p ~/.config/waybar
ln -s ~/arch-setup/hyprland/waybar/config.jsonc ~/.config/waybar/config.jsonc >/dev/null
ln -s ~/arch-setup/hyprland/waybar/style.css ~/.config/waybar/style.css >/dev/null
ln -s ~/arch-setup/hyprland/waybar/toggle-waybar.sh ~/.config/waybar/toggle-waybar.sh >/dev/null
ln -s ~/arch-setup/hyprland/waybar/ws_icons_event.sh ~/.config/waybar/ws_icons_event.sh >/dev/null
ln -s ~/arch-setup/hyprland/waybar/pomodoro.sh ~/.config/waybar/pomodoro.sh >/dev/null
echo "✅ Waybar symlink successfully setup"

# QuickShell
rm -rf ~/.config/quickshell
ln -s ~/arch-setup/hyprland/quickshell ~/.config/quickshell >/dev/null
echo "✅ QuickShell symlink successfully setup"

# Dunst
rm -rf ~/.config/dunst
mkdir -p ~/.config/dunst
ln -s ~/arch-setup/hyprland/dunst/dunstrc ~/.config/dunst/dunstrc >/dev/null
echo "✅ Dunst symlink successfully setup"

# Alacritty
rm -rf ~/.config/alacritty 
mkdir -p ~/.config/alacritty 
cat > ~/.config/alacritty/alacritty.toml << EOF
[window]
opacity = 0.80

[colors.primary]
background = "#000000"
EOF

# Hyprland
rm -rf ~/.config/hypr
mkdir -p ~/.config/hypr
ln -s ~/arch-setup/hyprland/hypr/hyprland.conf ~/.config/hypr/hyprland.conf >/dev/null 
ln -s ~/arch-setup/hyprland/hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf >/dev/null
ln -s ~/arch-setup/hyprland/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf >/dev/null 
mkdir -p ~/Pictures/Wallpapers
cp ~/arch-setup/hyprland/wallpapers/* ~/Pictures/Wallpapers/ -r >/dev/null 
echo "✅ hyprland.conf hyprlock.conf & hyprpaper.conf symlink successful setup"