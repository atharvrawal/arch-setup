#!/bin/bash
read -p "Do you want to install QEMU? (y/n): " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then

	source ~/arch-setup/complete-install/check-status.sh

	sudo pacman -S --needed --noconfirm \
		qemu-full \
		virt-manager \
		virt-viewer \
		dnsmasq \
		vde2 \
		bridge-utils \
		openbsd-netcat \
		usbutils \
		p7zip \
		libisoburn >/dev/null 2>&1
	check_status "Failed to install QEMU and related packages"
	echo "✅ QEMU and related packages installed successfully"
	echo ""

	# QEMU Service Setup
	sudo systemctl enable --now libvirtd
	check_status "Failed to enable libvirtd"
	sudo usermod -aG libvirt,kvm $USER
	sudo virsh net-start default 
	check_status "Failed to start default network"
	sudo virsh net-autostart default
	check_status "Failed to enable autostart for default network"
	echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.zshrc
	echo 'export EDITOR=nvim' >> ~/.zshrc
	mkdir -p ~/qemu
	echo "✅ QEMU Setup Successfull"
else
	echo "Skipping QEMU installation."
fi