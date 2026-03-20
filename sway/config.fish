set -g fish_greeting ""
alias ls='eza --icons'
alias la='eza -la --icons'
alias downclock='sudo cpupower frequency-set -u 1.0GHz'
alias resetclock='sudo cpupower frequency-set -u 3.30GHz'

alias win-off="sudo umount /mnt/Windows && echo 1 | sudo tee /sys/bus/pci/devices/0000:02:00.0/remove"
alias win-on="echo 1 | sudo tee /sys/bus/pci/rescan && sleep 2 && sudo mount /mnt/Windows"



# Only run in interactive shells
if status is-interactive
	fastfetch
end

set -U fish_prompt_pwd_dir_length 0

function fish_prompt
	echo ''
	set_color blue
	echo -n (prompt_pwd)

	# Git status
	if test -d .git
		set_color green
		echo -n ' on  ' (git branch --show-current)'*'
	end
	set_color magenta
	echo ''
	echo -n '❯ '
	set_color normal
end
