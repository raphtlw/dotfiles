# ** All variables MUST be exported **

# Path variables
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.poetry/bin"
export PATH="$PATH:$HOME/.pyenv/bin"
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$DENO_INSTALL/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.npm-global/bin"
export PATH="$PATH:$HOME/.deno/bin/deno"

export EDITOR="code"
export BROWSER="google-chrome-stable"
export DENO_INSTALL="/home/raphael/.deno"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Load cargo environment variables
source "$HOME/.cargo/env"
