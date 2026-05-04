fontforge -script patch.pe /usr/share/fonts/TTF/HackNerdFont-Regular.ttf HackCustom.ttf
cp HackCustom.ttf ~/.local/share/fonts/
fc-cache -fv >/dev/null 2>&1
echo "✅ Hack Nerd Font Patched and Installed Successfully"
echo ""