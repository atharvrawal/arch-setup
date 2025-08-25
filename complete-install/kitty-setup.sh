#!/bin/bash

source ~/arch-setup/complete-install/check-status.sh

# Kitty Setup
cd ~
chsh -s /bin/zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k >/dev/null 2>&1
check_status "Failed to clone powerlevel10k"
echo 'source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme'>>~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/autosuggestions >/dev/null 2>&1
check_status "Failed to clone zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/syntax-highlighting >/dev/null 2>&1 
check_status "Failed to clone zsh-syntax-highlighting"
echo 'source ~/.config/zsh/plugins/autosuggestions/zsh-autosuggestions.zsh'>>~/.zshrc
echo 'source ~/.config/zsh/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh'>>~/.zshrc
echo "alias ls='exa --icons'">>~/.zshrc
echo "alias la='ls -la'">>~/.zshrc
echo "alias lh='ls -lh'">>~/.zshrc
echo "alias i='sudo pacman -S'">>~/.zshrc
echo 'bindkey "^[[1;5D" backward-word      # Ctrl+Left'>>~/.zshrc
echo 'bindkey "^[[1;5C" forward-word       # Ctrl+Right'>>~/.zshrc
echo 'bindkey "^[[3~" delete-char          # Delete'>>~/.zshrc
echo 'bindkey "^H" backward-kill-word      # Ctrl+Backspace'>>~/.zshrc

echo 'HISTFILE=~/.config/zsh/zsh_history' >>~/.zshrc
echo 'HISTSIZE=10000' >>~/.zshrc
echo 'SAVEHIST=10000' >>~/.zshrc
echo 'setopt inc_append_history' >>~/.zshrc
echo 'setopt share_history' >>~/.zshrc
echo 'setopt hist_ignore_all_dups' >>~/.zshrc
echo 'setopt hist_reduce_blanks' >>~/.zshrc

mkdir -p ~/.config/kitty/
echo 'confirm_os_window_close 0'>>~/.config/kitty/kitty.conf

echo "✅ Kitty Setup Successful..."
echo ""