#!/usr/bin/env bash

#fail on any error
set -euo pipefail

echo "start installing..."
mkdir -p ~/.install

pacmanPkgs=(
	"man"
	"git"
        "github-cli"
	"zsh"
	"alacritty"
	"rofi"
	"hyprland"

	"fzf"
	"tree"
	"bat"
	"git-delta"

	"neovim"

	"neofetch"
)
sudo pacman -S --noconfirm --needed "${pacmanPkgs[@]}"

if sudo pacman -Qs yay > /dev/null; then
	echo "yay is installed. skipping..."
else 
	echo "installing yay..."
	git clone https://aur.archlinux.org/yay-git.git ~/.install/yay-git
	cd $HOME/.install/yay-git
	makepkg -si --noconfirm
	cd -
	rm -rf $HOME/.install/yay-git
fi

yayPkgs=(
	"google-chrome"
	"git-credential-manager-core"
)
yay -S --noconfirm --needed --answerdiff None --answerclean None "${yayPkgs[@]}"


if [[ $SHELL != "/usr/bin/zsh" ]]; then
	chsh -s $(which zsh)
else
	echo "skip setting default shell, because already set to ZSH"
fi

ohmyzshPath=$HOME/.oh-my-zsh
if [ ! -d $ohmyzshPath ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "skip installing ohmyzsh because $ohmyzshPath folder already exists"
fi

dotbarePath=$ohmyzshPath/custom/plugins/dotbare
if [ ! -d $dotbarePath ]; then
	git clone https://github.com/kazhala/dotbare.git $dotbarePath
else
	echo "skip installing dotbare because $dotbarePath folder already exists"
fi

isRTCInLocal=$(timedatectl status | awk -F'[:]+' '/RTC in local TZ/ {print $2}' | xargs)
if [ $isRTCInLocal != "yes" ]; then
	timedatectl set-local-rtc 1 --adjust-system-clock
else
	echo "skip setting local RTC because already set"
fi
