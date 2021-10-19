#!/bin/bash
read -p 'Computer name' hostname
read -p 'User name' username

echo 'We register the name of the computer'
echo $hostname > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo 'Add the Russian system locale'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Upgrade locale'
locale-gen

echo 'Locale system'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'We enter KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Install grub'
sudo pacman -Syy
sudo pacman -S grub efibootmgr  
grub-install /dev/sda

echo 'Upgrade grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Install Wi-fi menu'
sudo pacman -S dialog wpa_supplicant netctl dhclient iw dhcpcd iputils 

echo 'Add a user'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Root passwd'
passwd

echo 'Install passwd user'
passwd $username

echo 'Install SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo "Let's uncomment the multilib repository To run 32-bit applications on a 64-bit system."
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
sudo pacman -Syy

echo 'Install X11 draver'
sudo pacman -S xorg-server xorg-drivers xorg-xinit xorg-apps mesa xorg-twm xorg-xclock xorg xf86-input-synaptics vulkan-intel vulkan-icd-loader intel-ucode iucode-tool broadcom-wl-dkms

echo "Install I3-wm "
read -p "1 - Да, 2 - Нет: " wm
if [[ $wm == 1 ]]; then
    sudo pacman -S i3-wm dmenu pcmanfm conky conky-manager ttf-font-awesome feh gvfs udiskie xorg-xbacklight ristretto rofi pamac micro nitrogen compton jq --noconfirm
    yay -S polybar ttf-weather-icons ttf-clear-sans
    wget https://github.com/a77cascade/Arch_i3wm/blob/master/i3wm.tar.gz
    sudo rm -rf ~/.config/i3/*
    sudo rm -rf ~/.config/polybar/*
    sudo tar -xzf i3wm.tar.gz -C ~/
elif [[ $wm == 2 ]]; then
  echo 'Next'
fi

echo 'Install program'
sudo pacman -S reflector chromium veracrypt libreoffice libreoffice-fresh-ru qbittorrent firefox firefox-i18n-ru ufw f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol --noconfirm

echo 'Install DM'
sudo pacman -S lightdm lightdm-gtk-greeter
systemctl enable lightdm.service

echo 'Install ttf'
sudo pacman -S ttf-liberation ttf-dejavu noto-fonts ttf-roboto ttf-droid

echo 'Install NetworkManager'
sudo pacman -S networkmanager net-tools network-manager-applet ppp 

echo 'Start NetworkManager'
systemctl enable NetworkManager

echo 'Install wget git asp'
sudo pacman -Syu git wget curl asp
sudo pacman -S --noconfirm --needed wget curl asp
sudo pacman -S wget --noconfirm
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm

echo 'Installation is complete'
