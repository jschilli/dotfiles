alias ls="ls --color=auto"
alias ll="ls -l"
alias lh="ls -lh"
alias lls="ls -lh --sort=size --reverse"

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --git'
  alias a='eza -lr --sort newest'
fi
