#!/usr/bin/env bash

#fail on any error
set -euo pipefail

echo "start installing..."
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
	"git-credential-manager-core"
)
yay -S --noconfirm --needed --answerdiff None --answerclean None "${yayPkgs[@]}"

git config --global init.defaultBranch main
git config --global user.email ""
git config --global user.name "volaticus"
git config --global credential.credentialStore cache
git config --global credential.cacheOptions "--timeout 7200"  

if [[ $SHELL != "/usr/bin/zsh" ]]; then
	chsh -s $(which zsh)
else
	echo "shell not changed, already set to ZSH"
fi

if [ ! -d ~/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "skip installing ohmyzsh because ~/.oh-my-zsh folder already exists"
fi



