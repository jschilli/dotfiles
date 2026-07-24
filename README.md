# dotfiles

Jeff's Git, shell, terminal, and developer-tool configuration.

## Install

Requirements: Git, Make, and curl. Clone the repository into the persistent
home directory, then select the host profile:

```bash
git clone https://github.com/jschilli/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make linux
```

`make linux` is intended for Linux development VMs. It installs a portable Zsh
and login-shell environment, a Linux-safe Git configuration, Herdr, and the
Claude Code and Codex Herdr integrations. It is idempotent and keeps an existing
Herdr config.

On macOS:

```bash
make darwin
brew bundle --file=~/.dotfiles/Brewfile
```

The macOS installer keeps `~/.zshrc` as a regular local wrapper and adds one
source line for the tracked configuration. This lets endpoint-managed shell
settings remain local instead of writing through a symlink into the repository.
Other managed dotfiles refuse to replace existing regular files or unrelated
symlinks.

## Update

```bash
git -C ~/.dotfiles pull --ff-only
make -C ~/.dotfiles linux
```

The repository and installed configuration survive VM rebuilds when the home
directory is on a persistent volume.
