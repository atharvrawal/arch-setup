#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh

# Check if Rust is already installed
if command -v rustc >/dev/null 2>&1; then
    echo "Rust is already installed, skipping installation."
else
    # Rust Setup
    cd ~
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y  >/dev/null 2>&1
    check_status "Failed to install Rust"

    echo 'source $HOME/.cargo/env' >> ~/.zshrc
    check_status "Failed to add Rust to PATH"

    echo "Rust successfuly installed & added to PATH"
fi
