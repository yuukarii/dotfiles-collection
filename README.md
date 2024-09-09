# dotfiles-collection

## Install Arch Linux

- Prepare a bootable USB and boot to it.
- Verify the boot mode: cat /sys/firmware/efi/fw_platform_size (It should return 64).
- Connect to the internet via iwctl.
- Update the system clock.
- Partition the disks.
    - Example layout: /boot 1GB, swap = RAM = 16GB, / the rest of disk.
- Format the partitions.
- Mount the file systems.
- Select the mirrors.
- Install essential packages.
- Configure
    - fstab file.
    - Change root into the new system.
    - Install `vim`, `less`.
    - Set up timezone.
    - Localization.
    - Network configuration. (Install dhcpcd and networkmanager).
    - Change root password.
    - Install GRUB bootloader. Remember to generate the config file.
    - Install `sudo`.
    - Create my user, add it to sudoers file.

## Install i3wm and necessary packages
### Install sound
# Multimedia
ffmpeg
pipewire
pipewire-alsa
pipewire-audio
pipewire-pulse
pipewire-jack
wireplumber
gst-plugin-pipewire
pavucontrol

## Additionals

```bash
picom # Need for fixing screen tearing in firefox
```

```bash
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/i3 ~/.config/i3
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/polybar ~/.config/polybar
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/rofi ~/.config/rofi
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/alacritty ~/.config/alacritty
ln -s ~/Nextcloud/2-my-repos/dotfiles-collection/picom ~/.config/picom
```


## Install ibus

/etc/environment

GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus

To launch IBus on user login, create an autostart entry with the following command:

ibus-daemon -rxRd

it seems not work.

## Bluetooth
Control media by bluetooth buttons

~/.config/systemd/user/mpris-proxy.service

[Unit]
Description=Forward bluetooth media controls to MPRIS

[Service]
Type=simple
ExecStart=/usr/bin/mpris-proxy

[Install]
WantedBy=default.target

systemctl --user start mpris-proxy.service
systemctl --user status mpris-proxy.service
Then do a daemon-reload before you start/enable the service with the --user flag.

## Reduce heat of laptop

Installed TLP.
https://linrunner.de/tlp/support/optimizing.html: did Extend battery runtime and Reduce power consumption / fan noise on AC power.

yay -Syu powertop

/etc/systemd/system/powertop.service
```
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

yay -Syu cpupower
sudo cpupower frequency-set -g powersave
sudo systemctl enable cpupower --now

/etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="<something> amd_pstate=passive pcie_aspm=force"

sudo grub-mkconfig -o /boot/grub/grub.cfg

## TODO

- Configure rofi menu of wifi.
