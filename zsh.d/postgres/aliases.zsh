alias start_postgres="pg_ctl -D /usr/local/var/postgres start"
alias stop_postgres="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias pgup="start_postgres"
alias pgdown="stop_postgres"