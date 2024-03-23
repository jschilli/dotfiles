#!/bin/zsh

# make all

DOTFILE_PATH=$(pwd)

# install git stuff
ln -s $DOTFILE_PATH/gitconfig ~/.gitconfig
ln -s $DOTFILE_PATH/gitignore ~/.gitignore
ln -s $DOTFILE_PATH/githelpers ~/.githelpers

# install zsh stuff
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