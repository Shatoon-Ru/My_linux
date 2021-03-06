#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
timedatectl set-ntp true
hwclock --systohc --utc
sed -i '177s/.//' /etc/locale.gen
sed -i '403s/.//' /etc/locale.gen 
locale-gen
echo "LANG=ru_RU.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo "ArchPad" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 ArchPad.localdomain ArchPad" >> /etc/hosts
echo root:password | chpasswd #user_name:new_password
# Вы можете добавить xorg в установочные пакеты, я обычно добавляю его в сценарий установки DE или WM
# Вы можете удалить пакет tlp, если вы устанавливаете его на рабочий стол или виртуальную машину пакет для управления питанием

pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pulseaudio pavucontrol bash-completion openssh rsync acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font

# pacman -S --noconfirm xf86-video-intel
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg


systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m brain
echo brain:password | chpasswd
usermod -aG libvirt brain

echo "brain ALL=(ALL) ALL" >> /etc/sudoers.d/brain


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"




