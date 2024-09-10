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
    - Install GRUB bootloader. Remember to generate the config file.
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
yay -Syu libnotify
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
yay -Syu code code-features code-marketplace
```

## Login screen and lock screen
```bash
yay -Syu lightdm lightdm-slick-greeter

sudo systemctl enable lightdm.service
```

Modify `/etc/lightdm/lightdm.conf`
```conf
[Seat:*]
...
greeter-session=lightdm-slick-greeter
...
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
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/i3 ~/.config/i3
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/polybar ~/.config/polybar
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/rofi ~/.config/rofi
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/alacritty ~/.config/alacritty
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/picom ~/.config/picom
sudo cp ~/Nextcloud/2-my-repos/dotfiles-collection/tlp.conf /etc/tlp.conf
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

### Installed TLP
```bash
pacman -S tlp tlp-rdw
systemctl enable tlp.service
systemctl enable NetworkManager-dispatcher.service
systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

Extend battery runtim:
```bash
CPU_ENERGY_PERF_POLICY_ON_BAT=power
PLATFORM_PROFILE_ON_BAT=low-power # If available
CPU_BOOST_ON_BAT=0
CPU_HWP_DYN_BOOST_ON_BAT=0
```
Improve performance on AC Power
```bash
CPU_ENERGY_PERF_POLICY_ON_AC=performance
PLATFORM_PROFILE_ON_AC=performance # If available
```

Reduce power consumption:
```bash
RUNTIME_PM_ON_AC=auto
CPU_ENERGY_PERF_POLICY_ON_AC=balance_power
WIFI_PWR_ON_AC=on
```

### Install `powertop`

```bash
yay -Syu powertop
```

Create file `/etc/systemd/system/powertop.service`:
```conf
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
```

```bash
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
