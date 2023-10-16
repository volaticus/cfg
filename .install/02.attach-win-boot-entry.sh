#!/usr/bin/env bash
#fail on any error
set -euo pipefail


pacmanPkgs=(
	"edk2-shell"
)
sudo pacman -S --noconfirm --needed "${pacmanPkgs[@]}"

sudo cp /usr/share/edk2-shell/x64/Shell.efi /boot/shellx64.efi


blkid | grep vfat
#chek PARTUUID FS alias in boot shell 
sudo echo "HD1b:EFI\\Microsoft\\Boot\\Bootmgfw.efi" > /boot/windows.nsh

sudo echo "title  Windows
efi     /shellx64.efi
options -nointerrupt -noconsolein -noconsoleout windows.nsh" >> /boot/loader/entries/windows.conf

