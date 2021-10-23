#!/bin/bash

echo 'Russian Language'
loadkeys ru
setfont cyr-sun16

echo 'Temp'
timedatectl set-ntp true

echo 'Formatted sda'
mkfs.fat -F32 /dev/sda1
mkfs.jfs  /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mkfs.jfs  /dev/sda4
mkfs.reiserfs  /dev/sda6
mkfs.reiserfs  /dev/sda7
mkfs.reiserfs  /dev/sda8

echo 'Mounting'
mount /dev/sda2 /mnt
mkdir /mnt/home
mkdir /mnt/abook
mkdir /mnt/usr
mkdir /mnt/var
mkdir /mnt/tmp
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount /dev/sda4 /mnt/home
mount /dev/sda5 /mnt/abook
mount /dev/sda6 /mnt/usr
mount /dev/sda7 /mnt/var
mount /dev/sda8 /mnt/tmp

echo 'Mirrorlist'
pacman -Sy wget
rm -rf /etc/pacman.d/mirrorlist
wget https://git.io/mlist
mv -f ~/mlist /etc/pacman.d/mirrorlist
pacman -Syy

echo 'Install linux'
pacstrap /mnt base base-devel linux linux-firmware nano tor dhcpcd netctl dkms

echo 'System Setup'
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL git.io/i3wm2.sh)"
