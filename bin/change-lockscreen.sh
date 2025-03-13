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
cp "$image_file" "$wallpaper_dir/current-loginscreen.$file_extension"

# Update lightdm-gtk-greeter
lightdm_gtk_conf="/etc/lightdm/lightdm-gtk-greeter.conf"

if [ -f "$lightdm_gtk_conf" ]; then
  # Use sed to replace the line containing "feh"
  sed -i '/background/c\background = /usr/share/wallpapers/current-loginscreen.'"$file_extension" "$lightdm_gtk_conf"
  echo "Updated lightdm gtk config successfully"
else
  echo "lightdm gtk greeter file not found: $lightdm_gtk_conf"
fi

echo "Log in screen set successfully"
