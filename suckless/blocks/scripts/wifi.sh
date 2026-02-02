#!/bin/sh
# ssid() {
#     iw dev | awk '/ssid/ {printf "󰖩 %s", $2}'
# }

ssid() {
  timeout 0.1 iw dev 2>/dev/null | awk '/ssid/ {printf "󰖩 %s", $2}'
}

ip() {
    stdbuf -oL ip route get 1 | awk '{for(i=1;i<=NF;i++) if($i=="src") {printf "󰖩 %s", $(i+1)}}'
}

STATE="$HOME/.cache/dwmblocks-wifi"
[ -f "$STATE" ] || echo 1 > "$STATE"

read -r i < "$STATE"
case "$BLOCK_BUTTON" in
  1)    i=$((i % 2 + 1)); echo "$i" > "$STATE" ;;
esac

case "$i" in
  1) ssid ;;
  2) ip ;;
esac
