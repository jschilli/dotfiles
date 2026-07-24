#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
test_home=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")
darwin_home=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-darwin.XXXXXX")

cleanup() {
  rm -rf -- "$test_home" "$darwin_home"
}
trap cleanup EXIT HUP INT TERM

ln -s "$repo_dir" "$test_home/.dotfiles"
printf 'existing profile content\n' >"$test_home/.profile"
HOME=$test_home "$repo_dir/install" --profile linux --without-tools
HOME=$test_home "$repo_dir/install" --profile linux --without-tools

assert_link() {
  target=$1
  expected=$2
  [ -L "$target" ] || {
    printf 'expected symlink: %s\n' "$target" >&2
    exit 1
  }
  [ "$(readlink "$target")" = "$expected" ] || {
    printf 'unexpected symlink target for %s\n' "$target" >&2
    exit 1
  }
}

assert_link "$test_home/.zshrc" "$repo_dir/zshrc.linux"
assert_link "$test_home/.gitconfig" "$repo_dir/gitconfig.linux"
assert_link "$test_home/bin" "$repo_dir/bin"
cmp "$repo_dir/config/herdr/config.toml" "$test_home/.config/herdr/config.toml"

# shellcheck disable=SC2016
source_line='. "$HOME/.dotfiles/profile.linux"'
grep -Fqx 'existing profile content' "$test_home/.profile"
for shell_file in .profile .bash_profile .bashrc .zprofile; do
  [ "$(grep -Fxc "$source_line" "$test_home/$shell_file")" -eq 1 ] || {
    printf 'expected one Linux profile hook in %s\n' "$shell_file" >&2
    exit 1
  }
done

if command -v zsh >/dev/null 2>&1; then
  HOME=$test_home ZDOTDIR=$test_home TERM=xterm-256color zsh -lc '
    [[ "$path[1]" == "$HOME/.local/bin" ]]
    [[ "$path[2]" == "$HOME/.bun/bin" ]]
    [[ "$path[3]" == "$HOME/bin" ]]
    [[ "$path[4]" == "$HOME/.cargo/bin" ]]
  '
  HOME=$test_home ZDOTDIR=$test_home TERM=xterm-256color zsh -lic '
    alias cxa >/dev/null
    alias tl >/dev/null
  '
fi

ln -s "$repo_dir" "$darwin_home/.dotfiles"
printf 'endpoint-managed content\n' >"$darwin_home/.zshrc"
HOME=$darwin_home "$repo_dir/install" --profile darwin --without-tools
HOME=$darwin_home "$repo_dir/install" --profile darwin --without-tools
[ ! -L "$darwin_home/.zshrc" ]
grep -Fqx 'endpoint-managed content' "$darwin_home/.zshrc"
# shellcheck disable=SC2016
darwin_source_count=$(grep -Fxc '. "$HOME/.dotfiles/zshrc"' "$darwin_home/.zshrc")
[ "$darwin_source_count" -eq 1 ]

printf 'dotfiles installer tests passed\n'
