# If you use bash, this technique isn't really zsh specific. Adapt as needed.
source ~/.dotfiles/zsh.d/env-vars/keychain-environment-variables.sh

# AWS configuration example, after doing:
# $  set-keychain-environment-variable AWS_ACCESS_KEY_ID
#       provide: "AKIAYOURACCESSKEY"
# $  set-keychain-environment-variable AWS_SECRET_ACCESS_KEY
#       provide: "j1/yoursupersecret/password"
export AWS_ACCESS_KEY_ID=$(keychain-environment-variable AWS_ACCESS_KEY_ID);
export AWS_SECRET_ACCESS_KEY=$(keychain-environment-variable AWS_SECRET_ACCESS_KEY);

export PVOICE_ACCESS_KEY=$(keychain-environment-variable PVOICE_ACCESS_KEY);
export GH_ACCESS_TOKEN=$(keychain-environment-variable GH_ACCESS_TOKEN);