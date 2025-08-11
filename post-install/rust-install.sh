#!/bin/bash

source ~/arch-setup/post-install/check-status.sh

# Check if Rust is already installed
if command -v rustc >/dev/null 2>&1; then
    echo "Rust is already installed, skipping installation."
else
    # Rust Setup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    check_status "Failed to install Rust"

    source $HOME/.cargo/env
    check_status "Failed to add Rust to PATH"

    echo "Rust successfuly installed & added to PATH"
fi
