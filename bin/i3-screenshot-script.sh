#!/bin/bash

# Check if required tools are installed
check_dependencies() {
  local missing_deps=()

  for dep in maim xclip dunstify slop convert; do
    if ! command -v "$dep" &>/dev/null; then
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -ne 0 ]; then
    echo "Missing dependencies: ${missing_deps[*]}"
    echo "Please install them using:"
    echo "sudo pacman -S ${missing_deps[*]}"
    exit 1
  fi
}

# Create screenshots directory if it doesn't exist
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Create thumbnails directory
THUMBNAIL_DIR="/tmp/screenshot-thumbnails"
mkdir -p "$THUMBNAIL_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
THUMBNAIL="$THUMBNAIL_DIR/thumbnail_$(date +%Y%m%d_%H%M%S).png"

# Check for script arguments
case "$1" in
--full)
  # Capture full screen
  maim "$FILENAME"
  ;;
--select)
  # Capture selected area
  maim -s "$FILENAME"
  ;;
--active)
  # Capture active window
  maim -i "$(xdotool getactivewindow)" "$FILENAME"
  ;;
*)
  echo "Usage: $0 [--full|--select|--active]"
  echo "  --full    : Capture entire screen"
  echo "  --select  : Select area to capture"
  echo "  --active  : Capture active window"
  exit 1
  ;;
esac

# If screenshot was taken successfully
if [ -f "$FILENAME" ]; then
  # Create thumbnail
  magick "$FILENAME" -resize 100x100 "$THUMBNAIL"

  # Copy to clipboard
  xclip -selection clipboard -t image/png "$FILENAME"

  # Send notification with thumbnail
  dunstify -i "$THUMBNAIL" \
    "Screenshot taken" \
    "Saved as $(
      basename "$FILENAME"
    )\nCopied to clipboard" \
    -u normal

  # Clean up thumbnail after 5 seconds
  (sleep 5 && rm "$THUMBNAIL") &
else
  dunstify "Screenshot failed" \
    "Failed to capture screenshot" \
    -u critical
fi
