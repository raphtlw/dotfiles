# ~/.zshrc

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="code"
fi

eval "$(pyenv init -)"

# Aliases
alias tm="tmux attach || tmux new"
alias ls="exa"

# Starship
eval "$(starship init zsh)"
