#!/bin/bash
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

get_icon() {
  case "$1" in
    firefox* ) echo "" ;;
    code ) echo "󰨞" ;;
    foot ) echo "" ;;
    discord ) echo "" ;;
    vlc ) echo "󰕼" ;;
    albert ) echo "󰍉" ;;
    obsidian ) echo "󰠮" ;;
    elecwhat ) echo "󰖣" ;;
    * ) echo "" ;;
  esac
}

generate() {
  data=$(hyprctl clients -j)
  active=$(hyprctl activeworkspace -j | jq -r '.id')

  # ONE jq call → get workspace states
  mapfile -t wsdata < <(
    echo "$data" | jq -r '
      . as $clients
      | [range(1;10)]
      | map(
          . as $ws
          | ($clients | map(select(.workspace.id == $ws))) as $w
          | if ($w|length) == 0 then
              "empty"
            elif ($w | any(.urgent == true)) then
              "urgent"
            elif ($w|length) > 1 then
              "multi"
            else
              $w[0].class
            end
        )
      | .[]
    '
  )

  result=""

  for i in "${!wsdata[@]}"; do
    ws=$((i+1))
    entry="${wsdata[$i]}"

    if [ "$entry" = "urgent" ]; then
      icon="<span size='130%' foreground='#f7768e'>!</span>"
    elif [ "$entry" = "multi" ]; then
      icon="<span size='130%'>󰕭</span>"
    elif [ "$entry" = "empty" ]; then
      icon="$ws"
    else
      icon="<span size='130%'>$(get_icon "$entry")</span>"
    fi

    # highlight active workspace
    if [ "$ws" = "$active" ]; then
      icon="<span foreground='#ffffff'>$icon</span>"
    else
      icon="<span foreground='#888888'>$icon</span>"
    fi

    result="$result $icon "
  done

  result=${result% }
  echo "{\"text\": \"$result \"}"
}

generate

socat -U - UNIX-CONNECT:$SOCKET | while read -r line; do
  case "$line" in
    *openwindow*|*closewindow*|*movewindow*|*workspace*)
      generate
      ;;
  esac
done
