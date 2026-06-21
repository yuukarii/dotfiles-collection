#!/bin/sh
# Show i3 keybinds cheatsheet in rofi.
# Reads description from inline `# ...` or preceding `# ...` line.
awk '
{
  key = ""
  desc = ""
  if ($0 ~ /^[[:space:]]*bindsym[[:space:]]+/) {
    key = $0
    sub(/^[[:space:]]*bindsym[[:space:]]+/, "", key)
    if (match($0, /[[:space:]]#[[:space:]]/)) {
      desc = substr($0, RSTART + 1)
      sub(/^#[[:space:]]+/, "", desc)
    } else if (prev ~ /^#[[:space:]]+/) {
      desc = prev
      sub(/^#[[:space:]]+/, "", desc)
    }
    print key "  |  " desc
  }
  prev = $0
}
' ~/.config/i3/config | sort -u | rofi -dmenu -i -p 'i3 keybinds' -location 0 -theme ~/.config/rofi/keybinds.rasi
