if which nvim &> /dev/null; then
  alias vim='nvim'
fi

if which zed &> /dev/null; then
  export EDITOR='zed --wait'
  export VISUAL='zed --wait'
  export GIT_EDITOR='zed --wait'
elif which nvim &> /dev/null; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  export GIT_EDITOR='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
  export GIT_EDITOR='vim'
fi
