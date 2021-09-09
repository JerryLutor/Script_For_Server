# ~/.bashrc: executed by bash(1) for non-login shells.
COLOR_WHITE="\[\033[1;00m\]"
COLOR_RED="\[\033[1;31m\]"
COLOR_GREEN="\[\033[1;32m\]"
COLOR_YELLOW="\[\033[1;33m\]"
COLOR_BLUE="\[\033[1;34m\]"
COLOR_MAGENTA="\[\033[1;35m\]"
COLOR_CYAN="\[\033[1;36m\]"
COLOR_GREY="\[\033[1;37m\]"
export PS1="${COLOR_GREEN}\u${COLOR_WHITE}@${COLOR_CYAN}\h${COLOR_WHITE}:${COLOR_YELLOW}\w${COLOR_WHITE}$ "
export HISTCONTROL=erasedups
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias  grep='grep -n --color'
export GREP_COLOR='1;33'

alias ls='ls $LS_OPTIONS'
alias ll='ls -alF'
alias p='pwd'
if [[ $- == *i* ]]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi

#flussonic
alias valid='/opt/flussonic/contrib/validate_config.erl'
#dmesg
alias dmesg='dmesg -T'
#
#kill
alias kill='kill -9 '
#