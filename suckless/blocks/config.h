#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " | "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
#define BLOCKS(X)                                                         \
    X("  ",  "~/arch-setup/suckless/blocks/scripts/audio.sh",     0,  1)  /* signal only */      \
    X("󰃟 ",  "brightnessctl -m | cut -d, -f4",           0,  2)                         \
    X("󰖩 ",  "printf '%s  %s' \"$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)\" \"$(ip route get 1 | awk '{print $7}')\"", 60, 0) \
    X("  ", "awk '{u=$2+$4; t=$2+$4+$5} NR==1{pu=u; pt=t} NR==2{printf \"%.0f%%\", 100*(u-pu)/(t-pt)}' <(grep '^cpu ' /proc/stat; sleep 1; grep '^cpu ' /proc/stat)", 0, 0)    \
    X("  ",  "free -m | awk '/^Mem/ {printf \"%.0f%%\", ($3/$2)*100}'", 60, 0)            \
    X("󰁹 ", "printf '%s' $(cat /sys/class/power_supply/BAT0/capacity)", 60, 0)  \
    X(" ",  "printf '%s 󰥔 %s' \"$(date '+%a %d %b ')\" \"$(date '+%H:%M ')\"", 60, 0)

#endif  // CONFIG_H
