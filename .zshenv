# ** All variables MUST be exported **

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

export EDITOR="code"
export BROWSER="google-chrome-stable"
export DENO_INSTALL="/home/raphael/.deno"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# Load cargo environment variables
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
