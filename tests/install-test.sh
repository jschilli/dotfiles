#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
test_home=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")

cleanup() {
  rm -rf -- "$test_home"
}
trap cleanup EXIT HUP INT TERM

ln -s "$repo_dir" "$test_home/.dotfiles"
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

if command -v zsh >/dev/null 2>&1; then
  HOME=$test_home ZDOTDIR=$test_home TERM=xterm-256color zsh -lic '
    [[ "$PATH" == *"$HOME/.local/bin"* ]]
    [[ "$PATH" == *"$HOME/.bun/bin"* ]]
    alias cxa >/dev/null
    alias tl >/dev/null
  '
fi

printf 'dotfiles Linux installer test passed\n'
