alias ls='ls --color=auto -h'
alias ll='ls -l'
alias al='ll -a'
alias q='exit'

alias icat='kitten icat'
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh" 

alias del='maid'
alias rm='rm -iv'
alias sudo='sudo ' #TODO: why?

#dotfiles with bare git repo
alias configit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
