# ** All variables MUST be exported **

# Path variables
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.poetry/bin"
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$DENO_INSTALL/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.npm-global/bin"
export PATH="$PATH:$PYENV_ROOT/bin"

export EDITOR="code"
export BROWSER="google-chrome-stable"
export DENO_INSTALL="/home/raphael/.deno"
export PYENV_ROOT="$HOME/.pyenv"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/raphael/google-cloud-sdk/path.zsh.inc' ]; then . '/home/raphael/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/raphael/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/raphael/google-cloud-sdk/completion.zsh.inc'; fi
