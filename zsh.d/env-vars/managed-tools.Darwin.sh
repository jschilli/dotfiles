# Managed and installer-provided macOS tool configuration.

export PATH="$PATH:$HOME/.lmstudio/bin"

if [ -d "$HOME/.docker/completions" ]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

if [ -x "$HOME/anaconda3/bin/conda" ]; then
  __conda_setup="$("$HOME/anaconda3/bin/conda" shell.zsh hook 2>/dev/null)"
  if [ "$?" -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="$HOME/anaconda3/bin:$PATH"
  fi
  unset __conda_setup
fi

export PATH="$HOME/.amp/bin:$PATH"

[ -f "$HOME/.openclaw/completions/openclaw.zsh" ] &&
  source "$HOME/.openclaw/completions/openclaw.zsh"

if command -v dcg >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  if [ -f "$HOME/.claude/settings.json" ] &&
    ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg$"))' \
      "$HOME/.claude/settings.json" >/dev/null 2>&1; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi

export CARGO_TARGET_DIR="$HOME/.cargo-target/nightshift-rs"
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"
[ -f "$HOME/.daytona.completion_script.zsh" ] &&
  source "$HOME/.daytona.completion_script.zsh"

aikido_run="/Library/Application Support/AikidoSecurity/EndpointProtection/run"
npm_ca="$aikido_run/endpoint-protection-npm-cafile.pem"
ruby_ca="$aikido_run/endpoint-protection-ruby-combined-ca.pem"
openssl_ca="$aikido_run/endpoint-protection-openssl-combined-ca.pem"
node_ca="$aikido_run/endpoint-protection-node-combined-ca.pem"
python_ca="$aikido_run/endpoint-protection-pip-combined-ca.pem"

[ -r "$npm_ca" ] && export npm_config_cafile="$npm_ca"
[ -r "$ruby_ca" ] && export BUNDLE_SSL_CA_CERT="$ruby_ca"
if [ -r "$openssl_ca" ]; then
  export SSL_CERT_FILE="$openssl_ca"
  export CURL_CA_BUNDLE="$openssl_ca"
fi
[ -r "$node_ca" ] && export NODE_EXTRA_CA_CERTS="$node_ca"
if [ -r "$python_ca" ]; then
  export PIP_CERT="$python_ca"
  export REQUESTS_CA_BUNDLE="$python_ca"
  export POETRY_CERTIFICATES_PYPI_CERT="$python_ca"
fi
export UV_NATIVE_TLS=true
export UV_SYSTEM_CERTS=true

# Prefer the stable combined bundle over rotating endpoint-specific files.
if [ -r "$HOME/.config/aikido-ca/ca-bundle.pem" ]; then
  export AIKIDO_CA_BUNDLE="$HOME/.config/aikido-ca/ca-bundle.pem"
  export GIT_SSL_CAINFO="$AIKIDO_CA_BUNDLE"
  export CURL_CA_BUNDLE="$AIKIDO_CA_BUNDLE"
  export SSL_CERT_FILE="$AIKIDO_CA_BUNDLE"
  export NODE_EXTRA_CA_CERTS="$AIKIDO_CA_BUNDLE"
  export REQUESTS_CA_BUNDLE="$AIKIDO_CA_BUNDLE"
  export PIP_CERT="$AIKIDO_CA_BUNDLE"
  export POETRY_CERTIFICATES_PYPI_CERT="$AIKIDO_CA_BUNDLE"
  export BUNDLE_SSL_CA_CERT="$AIKIDO_CA_BUNDLE"
  export npm_config_cafile="$AIKIDO_CA_BUNDLE"
fi

unset aikido_run npm_ca ruby_ca openssl_ca node_ca python_ca
