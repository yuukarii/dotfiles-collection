#!/bin/bash

# Check if required tools are installed
check_dependencies() {
  local deps=(maim xclip dunstify)
  local missing_deps=()

  case "$1" in
  --active)
    deps+=(xdotool)
    ;;
  --select)
    if ! command -v slop &>/dev/null; then
      deps+=(slop)
    fi
    ;;
  esac

  if ! command -v magick &>/dev/null; then
    if ! command -v convert &>/dev/null; then
      missing_deps+=(imagemagick)
    fi
  fi

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      missing_deps+=("$dep")
    fi
  done

  if [ ${#missing_deps[@]} -ne 0 ]; then
    printf 'Missing dependencies: %s\n' "${missing_deps[*]}"
    exit 1
  fi
}

create_thumbnail() {
  if command -v magick &>/dev/null; then
    magick "$FILENAME" -resize 100x100 "$THUMBNAIL"
  else
    convert "$FILENAME" -resize 100x100 "$THUMBNAIL"
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
--full|--select|--active)
  check_dependencies "$1"
  ;;
*)
  echo "Usage: $0 [--full|--select|--active]"
  echo "  --full    : Capture entire screen"
  echo "  --select  : Select area to capture"
  echo "  --active  : Capture active window"
  exit 1
  ;;
esac

capture_ok=false
case "$1" in
--full)
  # Capture full screen.
  maim "$FILENAME" && capture_ok=true
  ;;
--select)
  # Capture selected area.
  maim -s "$FILENAME" && capture_ok=true
  ;;
--active)
  # Capture the active window.
  maim -i "$(xdotool getactivewindow)" "$FILENAME" && capture_ok=true
  ;;
esac

if "$capture_ok" && [ -s "$FILENAME" ]; then
  create_thumbnail

  # Copy the image bytes to the clipboard explicitly.
  xclip -selection clipboard -t image/png -i "$FILENAME"

  notify-send -i "$THUMBNAIL" \
    "Screenshot taken" \
    "Saved as $(basename "$FILENAME")\nCopied to clipboard" \
    -u normal

  (sleep 5 && rm -f "$THUMBNAIL") &
else
  rm -f "$FILENAME"
  dunstify "Screenshot failed" \
    "Failed to capture screenshot" \
    -u critical
  exit 1
fi
