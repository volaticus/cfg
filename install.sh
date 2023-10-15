#!/usr/bin/env bash

#fail on any error
set -euo pipefail

echo "start installing..."
mkdir -p ~/.install

pacmanPkgs=(
	"neofetch"
	"git"
        "github-cli"
)
sudo pacman -S --noconfirm --needed $pacmanPkgs
git config --global init.defaultBranch main


if sudo pacman -Qs yay > /dev/null; then
	echo "yay is installed. skipping..."
else 
	echo "installing yay..."
	git clone https://aur.archlinux.org/yay-git.git ~/.install/yay-git
	cd ~/.install/yay-git
	makepkg -si --noconfirm
	cd -
fi

yayPkgs=(
	"google-chrome"
)
yay -S --noconfirm --needed --answerdiff None --answerclean None $yayPkgs


