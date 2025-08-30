#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check if an image file is provided as parameter
if [ $# -eq 0 ]; then
  echo "Please provide an image file as parameter"
  exit 1
fi

# Get the image file from parameter
image_file="$1"

# Check if the file exists
if [ ! -f "$image_file" ]; then
  echo "File not found: $image_file"
  exit 1
fi

# Create /usr/share/wallpapers if it doesn't exist
wallpaper_dir="/usr/share/wallpapers"
mkdir -p "$wallpaper_dir"

# Get file extension
file_extension="${image_file##*.}"

# Copy the image to /usr/share/wallpapers with new name
cp "$image_file" "$wallpaper_dir/current-background.$file_extension"

# Update i3 config
i3_config="/home/yuukarii/.config/i3/config"

if [ -f "$i3_config" ]; then
  # Use sed to replace the line containing "feh"
  sed -i '/feh/c\exec_always --no-startup-id feh --bg-fill /usr/share/wallpapers/current-background.'"$file_extension" "$i3_config"
  echo "Updated i3 config successfully"
else
  echo "i3 config file not found: $i3_config"
fi

echo "Wallpaper set successfully"
