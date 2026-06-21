#!/usr/bin/env python3
"""Add inline `# description` to every bindsym in i3 config.
Idempotent: re-running won't duplicate comments.
"""
import re
import sys
from pathlib import Path

CONFIG = Path.home() / ".config/i3/config"

# (regex matching full bindsym line, description)
# Order matters: more specific patterns first.
DESCRIPTIONS = [
    # media / hardware keys
    (r"^bindsym \$mod\+Shift\+m ", "refresh hardware (gpu/display)"),
    (r"^bindsym XF86AudioRaiseVolume ", "volume up"),
    (r"^bindsym XF86AudioLowerVolume ", "volume down"),
    (r"^bindsym XF86AudioMute ", "toggle speaker mute"),
    (r"^bindsym XF86AudioMicMute ", "toggle microphone mute"),
    (r"^bindsym XF86MonBrightnessUp ", "brightness up"),
    (r"^bindsym XF86MonBrightnessDown ", "brightness down"),
    (r"^bindsym Print ", "screenshot fullscreen"),
    (r"^bindsym Shift\+Print ", "screenshot region (select area)"),
    (r"^bindsym Control\+Print ", "screenshot active window"),
    # launchers / apps
    (r"^bindsym \$mod\+comma ", "emoji picker (rofi)"),
    (r"^bindsym \$mod\+F1 ", "show i3 keybinds (this menu)"),
    (r"^bindsym \$mod\+Return ", "open terminal (kitty)"),
    (r"^bindsym \$mod\+b ", "open brave browser"),
    (r"^bindsym \$mod\+o ", "open obsidian"),
    (r"^bindsym \$mod\+q ", "kill focused window"),
    (r"^bindsym \$mod\+Shift\+p ", "power menu (logout/reboot/shutdown)"),
    (r"^bindsym \$mod\+Shift\+f ", "poweroff"),
    (r"^bindsym \$mod\+d ", "app launcher (rofi drun)"),
    # focus
    (r"^bindsym \$mod\+Left ", "focus left"),
    (r"^bindsym \$mod\+Down ", "focus down"),
    (r"^bindsym \$mod\+Up ", "focus up"),
    (r"^bindsym \$mod\+Right ", "focus right"),
    # move window
    (r"^bindsym \$mod\+Shift\+h ", "move window left"),
    (r"^bindsym \$mod\+Shift\+j ", "move window down"),
    (r"^bindsym \$mod\+Shift\+k ", "move window up"),
    (r"^bindsym \$mod\+Shift\+l ", "move window right"),
    (r"^bindsym \$mod\+Shift\+Left ", "move window left (arrow)"),
    (r"^bindsym \$mod\+Shift\+Down ", "move window down (arrow)"),
    (r"^bindsym \$mod\+Shift\+Up ", "move window up (arrow)"),
    (r"^bindsym \$mod\+Shift\+Right ", "move window right (arrow)"),
    # split / layout
    (r"^bindsym \$mod\+h split h", "split horizontal"),
    (r"^bindsym \$mod\+v split v", "split vertical"),
    (r"^bindsym \$mod\+f fullscreen toggle", "toggle fullscreen"),
    (r"^bindsym \$mod\+s ", "stacking layout"),
    (r"^bindsym \$mod\+w ", "tabbed layout"),
    (r"^bindsym \$mod\+e ", "toggle split layout"),
    (r"^bindsym \$mod\+Shift\+space ", "toggle floating"),
    (r"^bindsym \$mod\+space ", "toggle focus tiling/floating"),
    (r"^bindsym \$mod\+a ", "focus parent container"),
    # workspaces
    (r"^bindsym \$mod\+1 workspace", "switch to workspace 1"),
    (r"^bindsym \$mod\+2 workspace", "switch to workspace 2"),
    (r"^bindsym \$mod\+3 workspace", "switch to workspace 3"),
    (r"^bindsym \$mod\+4 workspace", "switch to workspace 4"),
    (r"^bindsym \$mod\+5 workspace", "switch to workspace 5"),
    (r"^bindsym \$mod\+6 workspace", "switch to workspace 6"),
    (r"^bindsym \$mod\+7 workspace", "switch to workspace 7"),
    (r"^bindsym \$mod\+8 workspace", "switch to workspace 8"),
    (r"^bindsym \$mod\+9 workspace", "switch to workspace 9"),
    (r"^bindsym \$mod\+Shift\+1 move", "move container to workspace 1"),
    (r"^bindsym \$mod\+Shift\+2 move", "move container to workspace 2"),
    (r"^bindsym \$mod\+Shift\+3 move", "move container to workspace 3"),
    (r"^bindsym \$mod\+Shift\+4 move", "move container to workspace 4"),
    (r"^bindsym \$mod\+Shift\+5 move", "move container to workspace 5"),
    (r"^bindsym \$mod\+Shift\+6 move", "move container to workspace 6"),
    (r"^bindsym \$mod\+Shift\+7 move", "move container to workspace 7"),
    (r"^bindsym \$mod\+Shift\+8 move", "move container to workspace 8"),
    (r"^bindsym \$mod\+Shift\+9 move", "move container to workspace 9"),
    (r"^bindsym \$mod\+x ", "move container to primary output"),
    # i3 control
    (r"^bindsym \$mod\+Shift\+c reload", "reload i3 config"),
    (r"^bindsym \$mod\+Shift\+r restart", "restart i3"),
    (r"^bindsym \$mod\+Shift\+e ", "exit i3 (log out)"),
    (r"^bindsym \$mod\+r mode \"resize\"", "enter resize mode"),
    # resize mode internals
    (r"^    bindsym j resize shrink width", "resize: shrink width"),
    (r"^    bindsym k resize grow height", "resize: grow height"),
    (r"^    bindsym l resize shrink height", "resize: shrink height"),
    (r"^    bindsym semicolon resize grow width", "resize: grow width"),
    (r"^    bindsym Left resize shrink width", "resize: shrink width (arrow)"),
    (r"^    bindsym Down resize grow height", "resize: grow height (arrow)"),
    (r"^    bindsym Up resize shrink height", "resize: shrink height (arrow)"),
    (r"^    bindsym Right resize grow width", "resize: grow width (arrow)"),
    (r"^    bindsym Return mode \"default\"", "resize: confirm"),
    (r"^    bindsym Escape mode \"default\"", "resize: cancel"),
    (r"^    bindsym \$mod\+r mode \"default\"", "resize: confirm (mod+r)"),
]

TRAILING_COMMENT = re.compile(r"\s*#.*$")


def main() -> int:
    text = CONFIG.read_text()
    lines = text.splitlines(keepends=True)

    matched = 0
    unmatched_bindings = []
    new_lines = []
    for line in lines:
        if not line.lstrip().startswith("bindsym ") or line.lstrip().startswith("#"):
            new_lines.append(line)
            continue
        hit = None
        for pat, desc in DESCRIPTIONS:
            if re.match(pat, line):
                hit = desc
                break
        stripped = TRAILING_COMMENT.sub("", line)
        stripped = stripped.rstrip() + f"  # {hit}\n" if hit else line
        if hit:
            matched += 1
        else:
            unmatched_bindings.append(line.rstrip())
        new_lines.append(stripped)

    CONFIG.write_text("".join(new_lines))
    print(f"Annotated {matched} bindsym lines.")
    if unmatched_bindings:
        print("UNMATCHED (no description added):")
        for b in unmatched_bindings:
            print(f"  {b}")
    return 0 if not unmatched_bindings else 1


if __name__ == "__main__":
    sys.exit(main())
