wash completions -d $HOME/.wash zsh
fpath=( $HOME/.wash "${fpath[@]}" )
[ -n "$ZSH" ] && [ -r $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh