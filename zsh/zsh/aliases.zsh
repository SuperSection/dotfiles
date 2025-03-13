# ls commands
alias ls='ls --color'
alias la='ls -a'
alias ll='ls -alh'
alias lu='ls -alu' # shows last Access time
alias lc='ls -alc' # shows last Change time

# general commands
alias vim='nvim'
alias cls='clear'
alias x='exit'
alias lg='lazygit'

# git commands
alias ginit='git init'
alias gadd='git add .'
alias gcommit='git commit -m'
alias grao='git remote add origin'
alias gs='git status'
alias glog='git log'
alias gcom='git add --all && git commit -m'
alias gb='git branch'
alias gchb='git checkout -b'
alias gch='git checkout'

# tmux commands
alias tnew='tmux new -s'
alias tat='tmux attach -t'
alias td='tmux detach'

# docker commands
alias dstop='docker stop $(docker ps -aq)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias dimg='docker images'
alias dnet='docker network ls'
alias dps='docker ps -a'
alias dconids='docker ps -aq'
