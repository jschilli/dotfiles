

# The rest of my fun git aliases
alias gcl='git clone'
alias gcle="cd ~/dev/extern && git clone"
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gwip="git commit -am 'wip'"
alias gdp='git checkout develop && git pull'
alias gdrb='gdbranch.sh'
alias grbl="git for-each-ref --sort=-committerdate --format='%(authorname) %(refname)' refs/remotes/origin"
alias gcnt="git log --oneline main.."

# gsync: status → pull → recent log, in one. Replaces the gs+gl+glog triple
# (the most common 3-step git workflow per atuin history, ~136 pairs/month).
# Usage: gsync [--dry-run] [--no-log]
gsync() {
  emulate -L zsh
  setopt err_return pipe_fail

  local dry_run=0 show_log=1
  for arg in "$@"; do
    case "$arg" in
      --dry-run) dry_run=1 ;;
      --no-log)  show_log=0 ;;
      -h|--help)
        print -- "gsync [--dry-run] [--no-log] — status, pull, then show recent log"
        return 0 ;;
      *) print -u2 "gsync: unknown arg: $arg"; return 2 ;;
    esac
  done

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    print -u2 "gsync: not a git repo"
    return 1
  fi

  # 1. Status snapshot
  local porcelain
  porcelain="$(git status --porcelain=v1 2>/dev/null)"
  local dirty=0
  [[ -n "$porcelain" ]] && dirty=1

  local branch
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || print -- '(no commits)')"
  print -P "%F{cyan}→ status:%f $branch"
  git status -sb | sed 's/^/  /'

  # 2. Dirty-tree policy — YOUR DECISION GOES HERE
  if (( dirty )); then
    if ! __gsync_handle_dirty "$porcelain" "$dry_run"; then
      print -P "%F{yellow}→ aborted by dirty-tree policy%f"
      return 1
    fi
  fi

  # 3. Pull
  print -P "%F{cyan}→ pulling...%f"
  if (( dry_run )); then
    print -- "  [dry-run] git pull --prune"
  else
    git pull --prune || return $?
  fi

  # 4. Recent log
  if (( show_log )); then
    print -P "%F{cyan}→ recent:%f"
    git log --graph --pretty=format:'  %Cred%h%Creset %an: %s -%Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative -10
    print
  fi
}

# __gsync_handle_dirty: TODO — define your dirty-tree policy.
#
# Args: $1 = porcelain output (non-empty), $2 = dry_run (0|1)
# Return: 0 to proceed with pull, non-zero to abort.
#
# Policy options to consider:
#   (a) auto-stash + pop after pull   (safest flow, but stash conflicts can bite)
#   (b) abort with a message          (forces you to handle it manually)
#   (c) proceed if only untracked     (pull is safe; merge conflicts only on tracked)
#   (d) interactive prompt            (zsh `read -q`)
#
# Write 5-10 lines below. Example skeleton (replace with your choice):
__gsync_handle_dirty() {
  local porcelain="$1"
  # Untracked lines start with "??". If anything else is present, tracked
  # changes exist and a pull could conflict — abort. Pure-untracked is safe.
  if print -- "$porcelain" | grep -qv '^??'; then
    print -u2 "gsync: tracked changes present — commit, stash, or discard first"
    return 1
  fi
  print -P "%F{yellow}→ untracked-only dirt, proceeding%f"
  return 0
}
