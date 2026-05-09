# dotfiles-collection

## Install Arch Linux

- Prepare a bootable USB and boot to it.
- Verify the boot mode: `cat /sys/firmware/efi/fw_platform_size` (It should return 64).
- Connect to the internet via `iwctl`.
- Update the system clock.
- Partition the disks.
    - Example layout: `/boot` 1GB, `swap` = RAM = 16GB, `/` = 100GB, `/home` the rest of disk.
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
yay -Syu i3-wm xorg-xinit xorg-server xorg-xrandr xdg-utils # choose noto-fonts
yay -Syu kitty
yay -Syu rofi feh picom dex
yay -Syu libnotify dunst
```

### File explorer
```bash
yay -Syu thunar nextcloud-client gvfs thunar-archive-plugin xarchiver tumbler rsync
```

### Install sound
```bash
yay -Syu pamixer pavucontrol ffmpeg pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber gst-plugin-pipewire
```

### Hardware driver
```bash
yay -Syu brightnessctl amd-ucode polkit

yay -Syu mesa libva-mesa-driver libvdpau-va-gl vdpauinfo
```

### Credentials
```bash
yay -Syu gnome-keyring libsecret keepassxc
```

### Development
```bash
yay -Syu code code-features code-marketplace
```

## Theme, Login screen and lock screen (do it when you completely free)

Choose everforest dark hard

```bash
yay -Syu lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
yay -Syu gnome-themes-extra gtk-engine-murrine colloid-everforest-gtk-theme-git lxappearance
yay -Syu colloid-icon-theme-git
sudo systemctl enable lightdm.service
yay -Syu betterlockscreen
yay -Syu bibata-cursor-theme

kitty +kitten themes
kitty list-fonts
```

Use lxappearance to change the theme and cursor.
```bash
sudo rm -rf /usr/share/icons/default
sudo ln -s /usr/share/icons/Bibata-Modern-Ice /usr/share/icons/default
```

### Auto start i3 at login
Add below line to `~/.xinitrc`:
```bash
exec /usr/bin/i3
```

Testing with `startx` from tty session.

### Install fonts
```bash
yay -Syu noto-fonts-cjk ttf-firacode-nerd rofi-emoji noto-fonts-emoji
```

## Install dotfiles

```bash
ln -s ~/dotfiles-collection/i3 ~/.config/i3
ln -s ~/dotfiles-collection/eww ~/.config/eww
ln -s ~/dotfiles-collection/rofi ~/.config/rofi
ln -s ~/dotfiles-collection/alacritty ~/.config/alacritty
ln -s ~/dotfiles-collection/picom ~/.config/picom
ln -s ~/dotfiles-collection/dunst ~/.config/dunst
ln -s ~/dotfiles-collection/fastfetch ~/.config/fastfetch
ln -s ~/dotfiles-collection/bin ~/.config/bin
ln -s ~/dotfiles-collection/betterlockscreen ~/.config/betterlockscreen
ln -s ~/dotfiles-collection/auto-cpufreq ~/.config/auto-cpufreq
ln -s ~/dotfiles-collection/zshrc ~/.zshrc
ln -s ~/dotfiles-collection/kitty ~/.config/kitty
```

## Install eww

```bash
yay -Syu libdbusmenu-gtk3 jq
```

Build from source. Choose rustup.

## Configure zram
```bash
yay -Syu zram-generator
sudo vim /etc/systemd/zram-generator.conf
[zram0]
zram-size = min(ram / 2, 16384)
```

## Bluetooth
```bash
yay -Syu bluez bluez-utils bluez-obex bluetui
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
```

> Control media by Bluetooth buttons

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

## Office

```bash
yay -Syu libreoffice-still zathura-pdf-poppler
```

Add this line to `~/.config/zathura/zathurarc`:
```
set selection-clipboard clipboard
```
to copy text to clipboard.

## Screenshot
```bash
yay -Syu maim xclip dunst xdotool slop imagemagick
```

## Virtualization

```bash
yay -Syu libvirt virt-manager qemu-desktop edk2-ovmf virt-viewer dnsmasq
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
usermod -aG libvirt <username>

yay -Syu docker docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
```

## Change shell to Zsh
To list all installed shells, run:
```bash
chsh -l
chsh -s /full/path/to/shell
sudo chsh -s /full/path/to/shell
```

## Reduce heat of laptop

> 28/02/2025, I faced an issue with auto-cpufreq that unable to change governor from performance to powersave. Install tlp fixed this.

### Install TLP

Follow this instruction: [TLP main page](https://linrunner.de/tlp/index.html).

### Install `powertop`

```bash
yay -Syu powertop
sudo cp dotfiles-collection/hardware/powertop.service /etc/systemd/system/powertop.service
systemctl enable powertop.service
systemctl start powertop.service
```

### Install `cpupower`

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

### Use fcitx5
```bash
yay -Syu fcitx5 fcitx5-configtool fcitx5-unikey fcitx5-qt fcitx5-gtk

vim ~/.xinitrc
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

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
### Bluetooth headset connected automatically but not have audio

Set trusted device.

### Open alacritty with a provision command
```bash
alacritty --hold -e btop
```

### Alacritty: Fix issue automatic change font size depending on monitor

Add this line to `~/.Xresources`
```
Xft.dpi: 96
```

### pacman tips
Pacman configurations `/etc/pacman.conf`:
```bash
# Misc options
#UseSyslog
Color
#NoProgressBar
CheckSpace
#VerbosePkgLists
ParallelDownloads = 5
ILoveCandy
```

### Reflector

Create configurations file:
```bash
reflector.conf --save /etc/pacman.d/mirrorlist --country Vietnam,Singapore --protocol https --latest 20 --sort rate
```

### feh tips

Set this command to open with option of images:
```bash
feh --scale-down --auto-zoom --start-at 
```

### GRUB_CONFIG

For AMD laptop (HP Elitebook 845 G9)

```bash
GRUB_DEFAULT=saved
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
GRUB_CMDLINE_LINUX=""
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL_INPUT=console
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true
GRUB_SAVEDEFAULT=true
GRUB_DISABLE_SUBMENU=y
GRUB_DISABLE_OS_PROBER=false
```

Generate config:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Public open Wifi

Connect to `neverssl.com` to activate the connection.


### Firefox
Enter `about:config` on the address bar and modify these parameters:
```
media.ffmpeg.vaapi.enabled	true
media.hardware-video-decoding.enabled	true
```

### Syncthing

```bash
yay -Syu syncthing
```

http://docs.syncthing.net/users/autostart.html#how-to-set-up-a-user-service

### Install Linux-lts kernel

```bash
yay -Syu linux-lts linux-lts-headers
sudo grub-mkconfig -o /boot/grub/grub.cfg
```