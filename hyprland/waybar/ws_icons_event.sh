#!/bin/bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# track active special workspace (numeric id, e.g. -97)
ACTIVE_SPECIAL=""

get_icon() {
  case "$1" in
    firefox*|Firefox*) echo "" ;;
    code|Code) echo "󰨞" ;;
    foot) echo "" ;;
    discord|Discord) echo "" ;;
    vlc|Vlc) echo "󰕼" ;;
    albert) echo "󰍉" ;;
    obsidian|Obsidian) echo "󰠮" ;;
    elecwhat) echo "󰖣" ;;
    thunar|Thunar) echo "" ;;
    *blanket*|*Blanket*) echo "󱑽" ;;
    *) echo "" ;;
  esac
}

generate() {
  data=$(hyprctl clients -j)

  # normal active workspace
  active=$(hyprctl activeworkspace -j | jq -r '.id')

  # collect workspace IDs (normal + special)
  mapfile -t ws_ids < <(
    jq -r '
      . as $clients
      | (
          [range(1;10)] +
          ($clients | map(.workspace.id) | map(select(. < 0)) |  unique | sort)
        )
      | .[]
    ' <<< "$data"
  )

  # workspace contents
  mapfile -t wsdata < <(
    jq -r '
      . as $clients
      | (
          [range(1;10)] +
          ($clients | map(.workspace.id) | map(select(. < 0)) | unique)
        )
      | map(
          . as $ws
          | ($clients | map(select(.workspace.id == $ws))) as $w
          | if ($w|length) == 0 then
              "empty"
            elif ($w | any(.urgent == true)) then
              "urgent"
            else
              ($w | map(.class) | join(" "))
            end
        )
      | .[]
    ' <<< "$data"
  )

  result=""
  added_divider=0

  for i in "${!ws_ids[@]}"; do
    ws="${ws_ids[$i]}"
    entry="${wsdata[$i]}"

    # insert divider before first special workspace
    if [ "$ws" -lt 0 ] && [ "$added_divider" = "0" ]; then
      result="$result <span size='130%' foreground='#555555'></span> "
      added_divider=1
    fi

    # label special workspace
    if [ "$ws" -lt 0 ]; then
      label="S$(( -ws ))"
    else
      label="$ws"
    fi

    if [ "$entry" = "urgent" ]; then
      icon="<span size='130%' foreground='#f7768e'>!</span>"

    elif [ "$entry" = "empty" ]; then
      icon="$label"

    else
      icons=""
      for cls in $entry; do
        icon_char=$(get_icon "$cls")
        icons="${icons}${icon_char}"
      done
      icons="${icons%}"
      icon="<span size='130%'>$icons</span>"
    fi

    # ✅ unified highlight logic (normal + special)
    if [ "$ws" = "$active" ] || [ "$ws" = "$ACTIVE_SPECIAL" ]; then
      icon="<span foreground='#ffffff'>$icon</span>"
    else
      icon="<span foreground='#888888'>$icon</span>"
    fi

    result="$result $icon "
  done

  result=${result% }
  echo "{\"text\": \"$result \"}"
}

# initial render
generate

# event loop
socat -U - UNIX-CONNECT:$SOCKET | while read -r line; do
  case "$line" in
    activespecialv2*)
      # extract workspace id reliably (-97, -98, etc.)
      ws_id=$(echo "$line" | awk -F'[>,]' '{print $3}')

      if [ -n "$ws_id" ]; then
        ACTIVE_SPECIAL="$ws_id"
      else
        ACTIVE_SPECIAL=""
      fi

      generate
      ;;

    *openwindow*|*closewindow*|*movewindow*|*workspace*)
      generate
      ;;
  esac
done