#!/bin/sh
# ssid() {
#     iw dev | awk '/ssid/ {printf "󰖩 %s", $2}'
# }

ssid() {
  # wifi_ssid=$(timeout 1 iw dev 2>/dev/null)
  # dev=$(ip route show default 2>/dev/null | awk '{print $5; exit}')
  # if [ -n "$wifi_ssid" ]; then
  #   printf "󰖩 %s" "$wifi_ssid"
  #   return
  # elif [ -n  "$dev" ]; then
  #   printf " %s" "$dev"
  #   return
  # else
  #   echo ""
  # fi
  dev=$(ip route show default 2>/dev/null | awk '{print $5; exit}')

  if [ -n "$dev" ] && iw dev "$dev" link 2>/dev/null | grep -q "Connected"; then
    wifi_ssid=$(iw dev "$dev" link | awk -F': ' '/SSID/ {print $2}')
    printf "󰖩 %s" "$wifi_ssid"
  elif [ -n "$dev" ]; then
    printf " %s" "$dev"
  else
    echo ""
  fi
}

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
