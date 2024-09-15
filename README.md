# dotfiles-collection

## Install Arch Linux

- Prepare a bootable USB and boot to it.
- Verify the boot mode: `cat /sys/firmware/efi/fw_platform_size` (It should return 64).
- Connect to the internet via `iwctl`.
- Update the system clock.
- Partition the disks.
    - Example layout: `/boot` 1GB, `swap` = RAM = 16GB, `/` the rest of disk.
- Format the partitions.
- Mount the file systems.
- Select the mirrors.
- Install essential packages.
- Configure
    - `fstab` file.
    - Change root into the new system.
    - Install `vim`, `less`.
    - Set up timezone.
    - Localization.
    - Network configuration. (Install `dhcpcd` and `networkmanager`).
    - Change root password.
    - Install GRUB bootloader. Remember to generate the configuration file.
    - Install `sudo`.
    - Create my user, change password add it to sudoers file.

## Install i3wm and necessary packages
### Install `yay`
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### i3wm and xorg
```bash
yay -Syu i3-wm i3lock xorg-xinit xorg-server xorg-xrandr xdg-utils # choose noto-fonts
yay -Syu alacritty
yay -Syu rofi polybar feh picom dex
yay -Syu libnotify dunst
```

### File explorer
```bash
yay -Syu thunar nextcloud-client gvfs thunar-archive-plugin xarchiver tumbler
```

### Install sound
```bash
yay -Syu pamixer pavucontrol ffmpeg pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber gst-plugin-pipewire
```

### Hardware driver
```bash
yay -Syu brightnessctl
```

### Credentials
```bash
yay -Syu gnome-keyring libsecret keepass
```

### Development
```bash
yay -Syu neovim
```

Install lazyvim.

## Login screen and lock screen
```bash
yay -Syu lightdm lightdm-gtk-greeter

sudo systemctl enable lightdm.service
```

### Auto start i3 at login
Add below line to `~/.xinitrc`:
```bash
exec /usr/bin/i3
```

### Install fonts
```bash
yay -Syu noto-fonts-cjk ttf-firacode-nerd
```

## Install dotfiles

```bash
ln -s ~/dotfiles-collection/i3 ~/.config/i3
ln -s ~/dotfiles-collection/polybar ~/.config/polybar
ln -s ~/dotfiles-collection/rofi ~/.config/rofi
ln -s ~/dotfiles-collection/alacritty ~/.config/alacritty
ln -s ~/dotfiles-collection/picom ~/.config/picom
ln -s ~/dotfiles-collection/dunst ~/.config/dunst
ln -s ~/dotfiles-collection/bin ~/.config/bin
```

## Bluetooth
```bash
yay -Syu bluez bluez-utils bluez-obex
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
```

> Control media by bluetooth buttons

Create file `~/.config/systemd/user/mpris-proxy.service`:
```conf
[Unit]
Description=Forward bluetooth media controls to MPRIS

[Service]
Type=simple
ExecStart=/usr/bin/mpris-proxy

[Install]
WantedBy=default.target
```

```bash
systemctl --user start mpris-proxy.service
systemctl --user status mpris-proxy.service
```

Then do a daemon-reload before you `start/enable` the service with the `--user` flag.

## Reduce heat of laptop

### Installed auto-cpufreq

### Install `powertop`

```bash
yay -Syu powertop
sudo cp dotfiles-collection/hardware/powertop.service /etc/systemd/system/powertop.service
systemctl enable powertop.service
systemctl start powertop.service
```

### Install `cpupower` (use auto-cpufreq instead)

```bash
yay -Syu cpupower
sudo cpupower frequency-set -g powersave
sudo systemctl enable cpupower --now
```

### Check polybar configurations

Scripts used in polybar create a lot of heat. Don't use `tail=true` for non-loop-infinity scripts, set the larger interval of modules.

The system reduces significantly from 48 degree Celcius to 38 degree Celcius after changing the interval.

## Issues

### External mouse, keyboard delay a bit before responding

This issue is due to USB suspend mode.
Use `powertop-autotune.sh` to fix this.

### Use ibus-bamboo
Set the combination to change typing method is Ctrl+Space

### Tailscale DNS fight

Install `resolvconf`:
```bash
pacman -Syu resolvconf # choose systemd-resolve dependency
sudo tailscale up --accept-dns
```

### yay issue after pacman updating.

```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```


