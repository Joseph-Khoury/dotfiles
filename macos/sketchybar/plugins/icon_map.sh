#!/usr/bin/env bash

app_icon() {
  case "$1" in
    "Finder") printf "󰀶" ;;
    "Firefox") printf "󰈹" ;;
    "Safari") printf "" ;;
    "Google Chrome"|"Chromium") printf "" ;;
    "Obsidian") printf "◆" ;;
    "Alacritty"|"Terminal"|"iTerm2"|"Ghostty"|"WezTerm") printf "" ;;
    "Code"|"Visual Studio Code") printf "󰨞" ;;
    "Zotero") printf "󰬫" ;;
    "Betterbird"|"Thunderbird"|"Mail") printf "󰇮" ;;
    "Nextcloud") printf "" ;;
    "Spotify") printf "" ;;
    "Discord") printf "" ;;
    "Steam") printf "" ;;
    "System Settings") printf "" ;;
    *) printf "•" ;;
  esac
}
