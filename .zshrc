# ~/.zshrc

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="code"
fi

# Aliases
alias tm="tmux attach || tmux new"
alias ls="exa"
alias lsa="ls -a"
alias l="ls -lah"
alias la="ls -lah"
alias ll="ls -lah"

# Starship
eval "$(starship init zsh)"
