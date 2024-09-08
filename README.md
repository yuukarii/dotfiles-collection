# dotfiles-collection

```bash
picom
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


## TODO

- Configure rofi menu of wifi.
