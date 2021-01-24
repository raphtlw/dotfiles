# ~/.zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
# autoload -Uz compinit
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
# 	compinit
# else
# 	compinit -C
# fi
# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C
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
alias xcopy="xclip -selection c"

# Disable Ctrl+s in terminal
# [[ -o interactive ]] && stty -ixon

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
zinit wait lucid atload'zicompinit; zicdreplay' blockf for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-completions
zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light lukechilds/zsh-better-npm-completion

# pyenv
if (( $+commands[pyenv] )); then
  eval "$(pyenv init - zsh --no-rehash)"
  # eval "$(pyenv virtualenv-init - zsh --no-rehash)"
fi

# nvm
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

# Blur
# if [[ $(ps --no-header -p $PPID -o comm) =~ '^yakuake|alacritty$' ]]; then
#   for wid in $(xdotool search --pid $PPID); do
#     xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid; done
# fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
