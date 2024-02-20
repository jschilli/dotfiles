alias get_idf='. $HOME/esp/esp-idf/export.sh'
alias hjs="pbpaste | highlight --syntax=js --font-size 24 --font Inconsolata --style molokai  -O rtf | pbcopy"

alias pgserver='function pgsql_server() { case $1 in "start") echo "Trying to start PostgreSQL..."; pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start ;; "stop") echo "Trying to stop PostgreSQL..."; pg_ctl -D /usr/local/var/postgres stop -s -m fast ;; esac }; pgsql_server'

alias lctouch-pb="rsync --progress --partial -avz ~/Google\ Drive/LinuxCNC/configs/github/linux-cnc-configs/linux-cnc-configs/g0704-probe-basic jscnc:./sync"
alias lctouch-v2="rsync --progress --partial -avz ~/Google\ Drive/LinuxCNC/configs/github/linux-cnc-configs/linux-cnc-configs/g0704-touch-v2 jscnc:./sync"
