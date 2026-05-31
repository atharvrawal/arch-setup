fontforge -script ~/arch-setup/hyprland/font-patch/patch.pe /usr/share/fonts/TTF/HackNerdFont-Regular.ttf HackCustom.ttf
cp ~/arch-setup/hyprland/font-patch/HackCustom.ttf ~/.local/share/fonts/
fc-cache -fv >/dev/null 2>&1
echo "✅ Hack Nerd Font Patched and Installed Successfully"
echo ""