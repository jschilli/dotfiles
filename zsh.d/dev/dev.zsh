alias cl="brew install --cask --no-quarantine humanlayer/humanlayer/codelayer-nightly && open /Applications/CodeLayer-Nightly.app"

ipnpm() {
  infisical run --env=dev pnpm "$@"
}

irun() {
  infisical run --env=dev "$@"
}