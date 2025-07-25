
# set -x

export ZSH=$HOME/.dotfiles/zsh.d

##############
# BASIC SETUP
##############

typeset -U PATH
autoload colors; colors;

#############
## PRIVATE ##
#############
# Include private stuff that's not supposed to show up
# in the dotfiles repo
local private="${HOME}/.zsh.d/private.sh"
if [ -e ${private} ]; then
  . ${private}
fi


# Only load nvm for interactive shells (nvm is slow to initialize)
if [[ -o interactive ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" # This loads nvm
fi

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt INC_APPEND_HISTORY     # Immediately append to history file.
setopt EXTENDED_HISTORY       # Record timestamp in history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Dont record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # Dont record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS      # Dont write duplicate entries in the history file.
setopt SHARE_HISTORY          # Share history between all sessions.
unsetopt HIST_VERIFY          # Execute commands using history (e.g.: using !$) immediately

#############
# COMPLETION
#############

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi


# Speed up completion init, see: https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# # load every completion after autocomplete loads
# for config_file ($ZSH/**/*completion.zsh) source $config_file

# source every .zsh file in this rep
for config_file ($ZSH/**/*.zsh) source $config_file


# unsetopt menucomplete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_pushd

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

###############
# KEY BINDINGS
###############

# Emacs Keybindings
bindkey -e


#########
# Aliases
#########

case $OSTYPE in
  linux*)
    local aliasfile="${HOME}/.zsh.d/aliases.Linux.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
  darwin*)
    local aliasfile="${HOME}/.zsh.d/aliases.Darwin.sh"
    [[ -e ${aliasfile} ]] && source ${aliasfile}
  ;;
esac

if type lsd &> /dev/null; then
  alias ls=eza --icons --git
fi
alias lls='ls -lh --sort=size --reverse'
alias llt='ls -lrt'
alias bear='clear && echo "Clear as a bear!"'
alias cat='bat'
alias find='fd'
alias grep='rg'

alias history='history 1'
alias hs='history | grep '

# Use rsync with ssh and show progress
alias rsyncssh='rsync -Pr --rsh=ssh'

# Edit/Source vim config
alias ez='vim ~/.zshrc'
alias sz='source ~/.zshrc'

# git
alias gs='git status -sb'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
# [c]heck [o]ut
alias co='git checkout'
# [f]uzzy check[o]ut
fo() {
  git branch --no-color --sort=-committerdate --format='%(refname:short)' | fzf --header 'git checkout' | xargs git checkout
}
# [p]ull request check[o]ut
po() {
  gh pr list --author "@me" | fzf --header 'checkout PR' | awk '{print $(NF-5)}' | xargs git checkout
}
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git Root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'

# tmux
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tmm='tmux new -s main'

# ceedee dot dot dot
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Notes
alias n='nvim +Notes' # Opens Vim and calls `:Notes`

# Go
alias got='go test ./...'

alias -g withcolors="| sed '/PASS/s//$(printf "\033[32mPASS\033[0m")/' | sed '/FAIL/s//$(printf "\033[31mFAIL\033[0m")/'"

alias zedn='/Applications/Zed\ Nightly.app/Contents/MacOS/cli'
alias r='cargo run'
alias rr='cargo run --release'

##########
# FUNCTIONS
##########

mkdircd() {
  mkdir -p $1 && cd $1
}

render_dot() {
  local out="${1}.png"
  dot "${1}" \
    -Tpng \
    -Nfontname='JetBrains Mono' \
    -Nfontsize=10 \
    -Nfontcolor='#fbf1c7' \
    -Ncolor='#fbf1c7' \
    -Efontname='JetBrains Mono' \
    -Efontcolor='#fbf1c7' \
    -Efontsize=10 \
    -Ecolor='#fbf1c7' \
    -Gbgcolor='#1d2021' > ${out} && \
    kitty +kitten icat --align=left ${out}
}

serve() {
  local port=${1:-8000}
  local ip=$(ipconfig getifaddr en0)
  echo "Serving on ${ip}:${port} ..."
  python -m SimpleHTTPServer ${port}
}

beautiful() {
  while
  do
    i=$((i + 1)) && echo -en "\x1b[3$(($i % 7))mo" && sleep .2
  done
}

spinner() {
  while
  do
    for i in "-" "\\" "|" "/"
    do
      echo -n " $i \r\r"
      sleep .1
    done
  done
}


# Open PR on GitHub
pr() {
  if type gh &> /dev/null; then
    gh pr view -w
  else
    echo "gh is not installed"
  fi
}

fpath=($ZSH/zsh/functions $fpath)

autoload -U $ZSH/zsh/functions/*(:t)


#########
# PROMPT
#########

# Only set up git prompt for interactive shells
if [[ -o interactive ]]; then
  setopt prompt_subst

  git_prompt_info() {
    local dirstatus=" OK"
    local dirty="%{$fg_bold[red]%} X%{$reset_color%}"

    if [[ ! -z $(git status --porcelain 2> /dev/null | tail -n1) ]]; then
      dirstatus=$dirty
    fi

    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo " %{$fg_bold[green]%}${ref#refs/heads/}$dirstatus%{$reset_color%}"
  }
else
  # Simple no-op function for non-interactive shells
  git_prompt_info() { return; }
fi

# local dir_info_color="$fg_bold[black]"

# This just sets the color to "bold".
# Future me. Try this to see what's correct:
#   $ print -P '%fg_bold[black] black'
#   $ print -P '%B%F{black} black'
#   $ print -P '%B black'
local dir_info_color="%B"

local dir_info_color_file="${HOME}/.zsh.d/dir_info_color"
if [ -r ${dir_info_color_file} ]; then
  source ${dir_info_color_file}
fi

# Only set up complex prompt for interactive shells
if [[ -o interactive ]]; then
  local dir_info="%{$dir_info_color%}%(5~|%-1~/.../%2~|%4~)%{$reset_color%}"
  local promptnormal="φ %{$reset_color%}"
  local promptjobs="%{$fg_bold[red]%}φ %{$reset_color%}"

  # Show how many nested `nix shell`s we are in
  # local `nix`_prompt=""
  # # Set ORIG_SHLVL only if it wasn't previously set and if SHLVL > 1 and
  # # GHOSTTY_RESOURCES_DIR is not empty
  # if [[ -z $ORIG_SHLVL ]]; then
  #   if [[ -z $GHOSTTY_RESOURCES_DIR ]]; then
  #     export ORIG_SHLVL=$SHLVL
  #   elif  [[ $SHLVL -gt 1 ]]; then
  #     export ORIG_SHLVL=$SHLVL
  #   fi
  # fi;
  # # If ORIG_SHLVL is set and SHLVL is now greater: display nesting level
  # if [[ ! -z $ORIG_SHLVL && $SHLVL -gt $ORIG_SHLVL ]]; then
  #   nix_prompt=("(%F{yellow}$(($SHLVL - $ORIG_SHLVL))%f) ")
  # fi;

  PROMPT='${dir_info}$(git_prompt_info) ${nix_prompt}%(1j.$promptjobs.$promptnormal)'
else
  # Simple prompt for non-interactive shells
  PROMPT='$ '
fi

simple_prompt() {
  local prompt_color="%B"
  export PROMPT="%{$prompt_color%}$promptnormal"
}

########
# ENV
########

export COLOR_PROFILE="dark"

case $OSTYPE in
  linux*)
    local envfile="${HOME}/.zsh.d/env.Linux.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
  darwin*)
    local envfile="${HOME}/.zsh.d/env.Darwin.sh"
    [[ -e ${envfile} ]] && source ${envfile}
  ;;
esac

export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Reduce delay for key combinations in order to change to vi mode faster
# See: http://www.johnhawthorn.com/2012/09/vi-escape-delays/
# Set it to 10ms
export KEYTIMEOUT=1

export PATH="$HOME/neovim/bin:$PATH"

if type nvim &> /dev/null; then
  alias vim="nvim"
  export EDITOR="nvim"
  export PSQL_EDITOR="nvim -c"set filetype=sql""
  export GIT_EDITOR="nvim"
else
  export EDITOR='vim'
  export PSQL_EDITOR='vim -c"set filetype=sql"'
  export GIT_EDITOR='vim'
fi

if [[ -e "$HOME/code/clones/lua-language-server/3rd/luamake/luamake" ]]; then
  alias luamake="$HOME/code/clones/lua-language-server/3rd/luamake/luamake"
fi


# rustup
export PATH="$HOME/.cargo/bin:$PATH"

# homebrew
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# Only initialize interactive tools for interactive shells
if [[ -o interactive ]]; then
  # mise
  if type mise &> /dev/null; then
    eval "$(mise activate zsh)"
  fi

  # direnv
  if type direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
  fi

  # fzf
  if type fzf &> /dev/null && type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
    export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/*"'
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  # Try out atuin
  if type atuin &> /dev/null; then
    eval "$(atuin init zsh)"
  fi
fi

# node.js
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

# golang
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Only load z (jump around) for interactive shells
if [[ -o interactive ]]; then
  # `z`
  if [ -e /usr/local/etc/profile.d/z.sh ]; then
    source /usr/local/etc/profile.d/z.sh
  fi

  if [ -e /opt/homebrew/etc/profile.d/z.sh ]; then
    source /opt/homebrew/etc/profile.d/z.sh
  fi
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Export my personal ~/bin as last one to have highest precedence
export PATH="$HOME/bin:$PATH"

export STARSHIP_CONFIG=~/.dotfiles/config/nerd-font-symbols.toml
# This loads nvm bash_completion[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Only initialize starship for interactive shells
if [[ -o interactive ]]; then
  eval "$(starship init zsh)"
fi
export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/jschilli/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

plugins=( git z )export PATH="$PATH:/Users/jschilli/Library/Warm/bin"

export BAT_THEME="Coldark-Dark"
. "$HOME/.local/bin/env"

. "$HOME/.grit/bin/env"
