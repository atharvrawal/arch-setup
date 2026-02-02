#!/bin/sh

cpu() {
  read -r _ a b c d e _ < /proc/stat
  sleep 1
  read -r _ A B C D E _ < /proc/stat
  printf "  %d%%" "$((100*((A+C)-(a+c))/((A+C+D)-(a+c+d))))"
}

mem() {
  free -m | awk '/^Mem/ {printf "  %.0f%%", ($3/$2)*100}'
}

bat() {
  awk '{printf "󰁹 %s", $0}' /sys/class/power_supply/BAT0/capacity
}

STATE="$HOME/.cache/dwmblocks-system"
[ -f "$STATE" ] || echo 1 > "$STATE"

read -r i < "$STATE"
case "$BLOCK_BUTTON" in
  1)    i=$((i % 3 + 1))
        echo "$i" > "$STATE"
        ;;
esac

case "$i" in
  1) bat ;;
  2) mem ;;
  3) cpu ;;
esac
