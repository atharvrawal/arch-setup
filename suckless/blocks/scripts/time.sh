#!/bin/sh

calander() {
    printf ' %s' "$(date '+%a %d %b')"
}

clock() {
    printf '󰥔 %s' "$(date '+%H:%M')"
}


STATE="$HOME/.cache/dwmblocks-time"
[ -f "$STATE" ] || echo 1 > "$STATE"

read -r i < "$STATE"
case "$BLOCK_BUTTON" in
  1)    i=$((i % 2 + 1))
        echo "$i" > "$STATE"
        ;;
esac

case "$i" in
  1) clock ;;
  2) calander ;;
esac
