# ** All variables MUST be exported **

# Regular variables
export EDITOR="code"
export BROWSER="brave"
export DENO_INSTALL="$HOME/.deno"
export PYENV_ROOT="$HOME/.pyenv"

# Path variables
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.poetry/bin"
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$DENO_INSTALL/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.npm-global/bin"
export PATH="$PATH:$HOME/.deno/bin/deno"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$PYENV_ROOT/bin"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# Load cargo environment variables
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Load pyenv environment variables
(( $+commands[pyenv] )) && eval "$(pyenv init --path)"
