# ** All variables MUST be exported **

# Regular variables
export EDITOR="code"
export BROWSER="brave"
export DENO_INSTALL="$HOME/.deno"
export PYENV_ROOT="$HOME/.pyenv"

# Path variables
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export PATH="$HOME/flutter/bin:$PATH"
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.deno/bin/deno:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# Load cargo environment variables
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Load pyenv environment variables
(( $+commands[pyenv] )) && eval "$(pyenv init --path)"
