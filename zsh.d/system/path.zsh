# Add nvm default node to PATH so node/npx are available in
# non-interactive shells and desktop apps (nvm itself only loads interactively)
if [ -d "$HOME/.nvm/versions/node" ]; then
  NVM_DEFAULT_DIR="$HOME/.nvm/versions/node/$(ls -1 "$HOME/.nvm/versions/node" | tail -1)/bin"
  export PATH="$NVM_DEFAULT_DIR:$PATH"
fi

export PATH=".:bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$HOME/bin:$ZSH/bin:$PATH"

export MANPATH="/usr/local/man:$MANPATH"

launchctl setenv PATH $PATH

NODE_PATH="/usr/local/lib/jsctags:$NODE_PATH"

#export PATH=$(npm config --global get prefix)/bin:$PATH:
export IDF_PATH=$HOME/esp/esp-idf

export PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# used to direct scps via `wbot()`
export WBOT_TARGET_PATH="wasm/"