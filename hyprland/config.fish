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



function phonepull
    set BASE "/storage/emulated/0"

    # detect subnet
    set SUBNET (ip route | awk '/default/ {print $3}' | sed 's/\.[0-9]*$//')

    set PHONE_IP (for i in (seq 1 254)
        echo "$SUBNET.$i"
    end | xargs -P 50 -I {} sh -c "nc -z -w 1 {} 42069 2>/dev/null && echo {}" | head -n1)

    # validate
    if test -z "$PHONE_IP"
        echo "Phone not found on LAN"
        return 1
    end

    echo "Using IP: $PHONE_IP"

    set CUR "$BASE"

    while true
        set CHOICE (ssh -p 42069 u0_a235@$PHONE_IP \
            "cd \"$CUR\" && echo '..'; ls -1p" \
            | fzf --prompt="$CUR > " --expect=ctrl-d)

        set KEY $CHOICE[1]
        set ITEM $CHOICE[2]

        if test -z "$ITEM"
            echo "Cancelled"
            return 1
        end

        if test "$ITEM" = ".."
            set CUR (dirname "$CUR")
            continue
        end

        if test "$KEY" = "ctrl-d"
            set TARGET "$CUR/$ITEM"
            break
        end

        if string match -q "*/" "$ITEM"
            set CUR "$CUR/"(string trim -r -c / "$ITEM")
        else
            set TARGET "$CUR/$ITEM"
            break
        end
    end

    rsync -avL --info=progress2 --whole-file \
        -e "ssh -p 42069" \
        u0_a235@$PHONE_IP:"$TARGET" .
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/atharv/.lmstudio/bin
# End of LM Studio CLI section

