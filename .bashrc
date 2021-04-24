#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#resize -s 29 80
#clear

# figlet moise moiseson
# neofetch

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
 
alias em='emacsclient -cn'
# alias clear='clear && figlet moise moiseson &&  neofetch '


export EDITOR='emacsclient -c'
export VISUAL=$EDITOR

colorscript -r


