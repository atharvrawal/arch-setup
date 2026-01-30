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
    X("🔊 ",  "~/.local/bin/volume.sh",     0,  1)  /* signal only */      \
    X("💡 ",  "brightnessctl g",           0,  2)                         \
    X("🌐 ",  "nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2", 10, 0) \
    X("🖥 ",  "free -h | awk '/^Mem/ {print $3\"/\"$2}'", 5, 0)            \
    X("🔋 ",  "cat /sys/class/power_supply/BAT0/capacity", 30, 0)         \
    X("📅 ",  "date '+%a %d %b %H:%M'",     30, 0)

#endif  // CONFIG_H
