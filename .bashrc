stty -ixon

HISTSIZE= HISTFILESIZE=

[[ $- != *i* ]] && return

#resize -s 29 80
#clear

# figlet moise moiseson
# neofetch

alias ls='ls --color=auto --group-directories-first'

alias em='emacsclient -cn'

alias p="sudo pacman"

alias v="vim"

alias mkd="mkdir -pv"

alias grep="grep --color=auto"

alias ccat="highlight --out-format=ansi"

alias rk="setxkbmap -layout se -option 'ctrl:nocaps'; xcape -e 'Control_L=Escape'"

export EDITOR='emacsclient -c'
export VISUAL=$EDITOR

colorscript -r
