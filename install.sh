#!/usr/bin/env sh

set -e

DOTFILE_PATH=$(pwd)
export DOTFILE_PATH;

# install git stuff
ln -s $DOTFILE_PATH/gitconfig ~/.gitconfig
ln -s $DOTFILE_PATH/gitignore ~/.gitignore
ln -s $DOTFILE_PATH/githelpers ~/.githelpers

# install zsh stuff
if `which starship`; then
  # all good
  echo "starship already installed"
  else
  	sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

fi
# does a zshrc already exist?
if [ -f ~/.zshrc ]; then
  echo "zshrc already exists"
  if grep -q ".dotfiles" ~/.zshrc; then
    echo "zshrc already has .dotfiles"
  else
    echo "zshrc does not have .dotfiles"
    echo . ~/.dotfiles/zshrc >> ~/.zshrc
  fi
else
  echo "zshrc does not exist"
  ln -s $DOTFILE_PATH/zshrc ~/.zshrc
fi

#instal bins
ln -s $DOTFILE_PATH/bin ~/bin