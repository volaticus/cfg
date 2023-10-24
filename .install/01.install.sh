#!/usr/bin/env bash

#fail on any error
set -euo pipefail

echo "start installing..."
mkdir -p ~/.install

echo "installing pacman packages..."
sudo pacman -S --noconfirm --needed - <$HOME/.install/01.packages-pacman.txt

if sudo pacman -Qs yay >/dev/null; then
	echo "yay is installed. skipping..."
else
	echo "installing yay..."
	git clone https://aur.archlinux.org/yay-git.git ~/.install/yay-git
	cd $HOME/.install/yay-git
	makepkg -si --noconfirm
	cd -
	rm -rf $HOME/.install/yay-git
fi

echo "installing yay packages..."
yay -S --noconfirm --needed --answerdiff None --answerclean None - <$HOME/.install/01.packages-yay.txt

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

alacrittyThemePath=$HOME/.config/alacritty/catppuccin
if [ ! -d $alacrittyThemePath ]; then
	git clone https://github.com/catppuccin/alacritty.git $alacrittyThemePath
else
	echo "skip installing alacritty theme because $alacrittyThemePath folder already exists"
fi

powerline10kPath=$ohmyzshPath/custom/themes/powerlevel10k
if [ ! -d $powerline10kPath ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $powerline10kPath
else
	echo "skip installing dotbare because $powerline10kPath folder already exists"
fi

sddmThemePath=/usr/share/sddm/themes/catppuccin-mocha
if [[ ! -d $sddmThemePath ]]; then
	rm -rf $HOME/.install/sddm-catppuccin-theme 2>/dev/null
	git clone https://github.com/catppuccin/sddm.git $HOME/.install/sddm-catppuccin-theme
	sudo rm -rf $sddmThemePath 2>/dev/null
	sudo cp -r $HOME/.install/sddm-catppuccin-theme/src/catppuccin-mocha $sddmThemePath
else
	echo "skip installing sddm theme because allready installed"
fi

sudo mkdir -p /etc/sddm.conf.d
echo "Regeneratig SDDM config:"
echo "
[Theme]
Current=catppuccin-mocha
" | sudo tee /etc/sddm.conf.d/sddm.conf
echo "------"

# /usr/share/sddm/scripts/Xsetup
# #!/bin/sh
# # Xsetup - run as root before the login dialog appears
# xrandr --output DP-1 --primary --auto
# xrandr --output DP-2 --left-of DP-1 --noprimary

nvimCfgPath=$HOME/.config/nvim
if [[ ! -d $nvimCfgPath ]]; then
	# backup
	# mv ~/.config/nvim{,.bak}
	# mv ~/.local/share/nvim{,.bak}
	# mv ~/.local/state/nvim{,.bak}
	# mv ~/.cache/nvim{,.bak}

	git clone https://github.com/LazyVim/starter $HOME/.config/nvim
	rm -rf $HOME/.config/nvim/.git
else
	echo "skip installing lazyvim because $nvimCfgPath alredy exists"
fi

if [[ ! -f $HOME/.config/rofi/config.rasi ]]; then
	git clone https://github.com/catppuccin/rofi.git $HOME/.install/roficatppuccin

	cd $HOME/.install/roficatppuccin/basic
	./install.sh
	cd -

	rm -rf $HOME/.install/roficatppuccin
else
	echo "skip installing rofi theme because already exists"
fi
