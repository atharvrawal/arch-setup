#!/bin/bash

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

echo "Dark Theme & Thunar Setup Successfull..."
echo ""