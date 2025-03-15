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
yay -Syu thunar nextcloud-client gvfs thunar-archive-plugin xarchiver tumbler
```

### Install sound
```bash
yay -Syu pamixer pavucontrol ffmpeg pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber gst-plugin-pipewire
```

### Hardware driver
```bash
yay -Syu brightnessctl amd-ucode polkit
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
yay -Syu betterlockscreen xidlehook

kitty +kitten themes
kitty list-fonts
```

### Auto start i3 at login
Add below line to `~/.xinitrc`:
```bash
exec /usr/bin/i3
```

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

Build from source. Choose rustup.

## Bluetooth
```bash
yay -Syu bluez bluez-utils bluez-obex
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
```

## Change shell to Zsh
To list all installed shells, run:
```bash
chsh -l
chsh -s /full/path/to/shell
```

Remember changing for `root` user also.

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

### Use ibus-bamboo
Set the combination to change typing method is `Ctrl+Space`

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
```
/etc/xdg/reflector/reflector.conf
---------------------------------
--save /etc/pacman.d/mirrorlist
--country Vietnam,Singapore
--protocol https
--latest 5
--sort rate
```

Start reflector service:
```bash
sudo systemctl enable reflector.service
sudo systemctl start reflector.service
```

### feh tips

Set this command to open with option of images:
```bash
feh --scale-down --auto-zoom --start-at 
```

### GRUB_CONFIG

For AMD laptop (HP Elitebook 845 G9)

```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash nowatchdog mitigations=off nospectre_v2 nopti l1tf=off no_stf_barrier spec_store_bypass_disable=off randomize_kstack_offset=off slab_nomerge init_on_free=0 init_on_alloc=0 audit=0 selinux=0 apparmor=0 security=none page_alloc.shuffle=0 iommu=pt nohz_full=0-$(nproc) rcu_nocbs=0-$(nproc) amd_pstate=active"

GRUB_DISABLE_SUBMENU=y
```