# Only load Azure completion for interactive shells
if [[ -o interactive ]]; then
  autoload bashcompinit && bashcompinit
  source $(brew --prefix)/etc/bash_completion.d/az
fi