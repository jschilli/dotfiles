# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

# alias a="ls -lrthG"
alias a="eza -lr --sort newest"
alias xcode='open *.xcodeproj'
alias sym='atos -arch x86_64 -o Tickets'
alias csv="codesign --verify -vvvv -R='anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.1] exists and (certificate leaf[field.1.2.840.113635.100.6.1.2] exists or certificate leaf[field.1.2.840.113635.100.6.1.4] exists)'"

# the "kp" alias ("que pasa"), in honor of tony p.
alias kp="ps auxwww"
alias crd="adb forward tcp:9222 localabstract:chrome_devtools_remote"
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
alias srvit='python -m SimpleHTTPServer'

alias bup='be rake clean && be rackup'
alias brt='bundle exec rake test'
alias hjs="pbpaste | highlight --syntax=js --font-size 24 --font Inconsolata --style molokai  -O rtf | pbcopy"

alias pgserver='function pgsql_server() { case $1 in "start") echo "Trying to start PostgreSQL..."; pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start ;; "stop") echo "Trying to stop PostgreSQL..."; pg_ctl -D /usr/local/var/postgres stop -s -m fast ;; esac }; pgsql_server'

alias lctouch-pb="rsync --progress --partial -avz ~/Google\ Drive/LinuxCNC/configs/github/linux-cnc-configs/linux-cnc-configs/g0704-probe-basic jscnc:./sync"
alias lctouch-v2="rsync --progress --partial -avz ~/Google\ Drive/LinuxCNC/configs/github/linux-cnc-configs/linux-cnc-configs/g0704-touch-v2 jscnc:./sync"