#!/bin/bash

rm /tmp/wallpaper.jpg
hyprctl hyprpaper unload /tmp/wallpaper.jpg
curl -L "https://picsum.photos/1920/1080" -o /tmp/wallpaper.jpg
hyprctl hyprpaper preload /tmp/wallpaper.jpg
hyprctl hyprpaper wallpaper eDP-1,/tmp/wallpaper.jpg
