#!/bin/bash

sudo pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings i3 lxappearance nitrogen arandr terminator picom dmenu rofi firefox pcmanfm flatpak python-requests gnome-system-monitor pacman-contrib playerctl pavucontrol python-dbus dunst archlinux-wallpaper awesome-terminal-fonts ttf-font-awesome scrot vlc firefox
sudo pacman -R --noconfirm i3lock
pikaur -S --noconfirm bumblebee-status betterlockscreen
flatpak install -y  spotify
flatpak install -y  kdenlive
sudo systemctl enable lightdm
