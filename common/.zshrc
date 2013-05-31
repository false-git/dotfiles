# users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
#
#export LANG=ja_JP.UTF-8

## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;;
*)
  if [ "x$TERM" = "xdumb" ] ; then
    PROMPT="[%.]%% "
    RPROMPT=""
    PROMPT2="%_%% "
    SPROMPT="%r is correct? [n,y,a,e]: "
  else
    PROMPT="%{${fg[red]}%}%n@%m[%.]%%%{${reset_color}%} "
    RPROMPT="[%{${fg[red]}%}%(5~,%-2~/.../%2~,%~)%{${reset_color}%}]"
    PROMPT2="%{${fg[red]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  fi
#  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
#  ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# remove postfix slash of command line
#
setopt auto_remove_slash

# no beep sound when complete list displayed
#
setopt nolistbeep

setopt pushd_ignore_dups

# コマンドラインの引数で --PREFIX=/USR などの = 以降でも補完できる
setopt magic_equal_subst

# rm * で警告しない
setopt rm_star_silent
# TAB で最初の候補を自動的に選択しない
setopt no_auto_menu

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
# to end of it)
#
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

## Completion configuration
#
autoload -U compinit
compinit

## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
  alias ls="ls -GwF"
  alias top="top -o cpu"
  ;;
linux*)
  alias ls="ls --color"
  ;;
esac

alias l="ls -lF"
alias ll="ls -lF"
alias la="ls -laF"

alias c="clear"

alias cx="cd .."
alias cxx="cd ../.."

alias em="emacsclient -n"

alias du="du -h"
alias df="df -h"

alias su="su -l"

## terminal configuration
#
unset LSCOLORS
case "${TERM}" in
xterm)
  export TERM=xterm-color
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
esac

# set terminal title
#
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac

cdpath=(~ ..)

agent="$HOME/tmp/ssh-agent-$USER"
lockfile="$HOME/tmp/ssh-agent-lock"
if [ -x /usr/bin/lockfile ]; then
    /usr/bin/lockfile $lockfile
fi
if [ -S $agent ]; then
	if [ "x$SSH_AUTH_SOCK" != "x" ]; then
		export SSH_AUTH_SOCK_ORIG=$SSH_AUTH_SOCK
	fi
	export SSH_AUTH_SOCK=$agent
elif [ -S "$SSH_AUTH_SOCK" ]; then
	case $SSH_AUTH_SOCK in
	/tmp/*/agent.[0-9]*|/tmp/launch-*/Listeners|/tmp/keyring-*/ssh)
		ln -snf "$SSH_AUTH_SOCK" $agent
	esac
	export SSH_AUTH_SOCK=$agent
else
	echo "no ssh-agent"
fi
if [ -f $lockfile ]; then
    rm -f $lockfile
fi

## load user .zshrc configuration file
#
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine
