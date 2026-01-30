#!/bin/sh

case $BLOCK_BUTTON in
  1) pamixer -t ;;
  3) pavucontrol ;;
  4) pamixer -i 5 ;;
  5) pamixer -d 5 ;;
esac

pamixer --get-volume-human
