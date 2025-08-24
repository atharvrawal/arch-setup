#!/bin/bash

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt,kvm $USER
sudo virsh net-start default
sudo virsh net-autostart default
echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.zshrc
echo 'export EDITOR=nvim' >> ~/.zshrc

mkdir ~/qemu ~/qemu/arch ~/qemu/windows
cd ~/qemu/arch



