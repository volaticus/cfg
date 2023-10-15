#!/usr/bin/env bash

#fail on any error
set -euo pipefail

echo "start installing..."
echo "enter your name:" 
read myName
echo "enter your email:" 
read myEmail

mkdir -p ~/.install

pacmanPkgs=(
	"git"
        "github-cli"
	"zsh"
	"alacritty"
	"hyprland"

	"neofetch"
)
sudo pacman -S --noconfirm --needed "${pacmanPkgs[@]}"
git config --global init.defaultBranch main
git config --global user.email "$myEmail"
git config --global user.name "$myName"
  
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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
yay -S --noconfirm --needed --answerdiff None --answerclean None "${yayPkgs[@]}"


