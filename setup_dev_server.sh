#! /bin/sh

# Setup Oh-my-zsh
sh -c "$(curl -fsSL -x fwdproxy:8080 https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ./.zshrc ~/.zshrc
touch ~/.profile
echo "exec /bin/zsh" >> ~/.profile

# Setup Neovim
mkdir --parents ~/.config/nvim/
cp ./init.vim ~/.config/nvim/
sudo dnf -y install neovim
sudo dnf -y install python2-neovim python3-neovim

# Run ycm install script for ycm
