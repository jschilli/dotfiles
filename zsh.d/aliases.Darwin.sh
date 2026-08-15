alias ls="ls -G"
alias ll="ls -G -l"
alias lh="ls -G -lh"
alias lls="ls -lhSr"
alias zedn='/Applications/Zed\ Nightly.app/Contents/MacOS/cli'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --git'
  alias a='eza -lr --sort newest'
fi
