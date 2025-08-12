#!/bin/bash

source ~/arch-setup/post-install/check-status.sh

yay -S --needed --noconfirm hyprland-git >/dev/null 2>&1
check_status 