# ~/.zshrc

# Options
setopt hist_ignore_all_dups
setopt inc_append_history
setopt hist_reduce_blanks
setopt always_to_end
setopt auto_list
setopt auto_menu
setopt auto_cd

# Autocompletion
fpath=(~/.zsh $fpath)
autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi
zmodload -i zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_USE_ASYNC=true

# History for autosuggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

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
alias l="ls -lahb"
alias la="l"
alias ll="l"
alias vim="nvim"
alias vi="nvim"
alias please="sudo"

# Starship
eval "$(starship init zsh)"

# Disable Ctrl+s in terminal
stty -ixon

# zinit plugin manager setup
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-as-monitor \
  zinit-zsh/z-a-patch-dl \
  zinit-zsh/z-a-bin-gem-node

# Plugins
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for \
  zsh-users/zsh-autosuggestions
zinit wait lucid for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Blur
# if [[ $(ps --no-header -p $PPID -o comm) =~ '^yakuake|alacritty$' ]]; then
#   for wid in $(xdotool search --pid $PPID); do
#     xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
# fi
