# ls commands
alias ls='ls --color'
alias la='ls -a'
alias ll='ls -alh'
alias lu='ls -alu' # shows last Access time
alias lc='ls -alc' # shows last Change time

# general commands
alias vim='nvim'
alias c='clear'
alias x='exit'
alias lg='lazygit'

# system commands
alias poweroff='sudo systemctl poweroff'
alias suspend='sudo systemctl suspend'
alias reboot='sudo systemctl reboot'

# windows mount
alias C='cd /mnt/windows_C'
alias D='cd /mnt/windows_D'

# git commands
alias ginit='git init'
alias ga='git add .'
alias gc='git commit -m'
alias gcom='git add --all && git commit -m'
alias grao='git remote add origin'
alias gs='git status -s'
alias glog='git log'
alias gl='git log --oneline --graph --all'
alias gb='git branch'
alias gchb='git checkout -b'
alias gch='git checkout'

# tmux commands
alias tnew='tmux new -s'
alias tat='tmux attach -t'
alias td='tmux detach'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
# calls the tmux new session script
alias tns="~/scripts/tmux-sessionizer"

# fzf 
# called from ~/scripts/
alias nlof="~/scripts/fzf_listoldfiles.sh"
# opens documentation through fzf (eg: git,zsh etc.)
alias fman="compgen -c | fzf | xargs man"

# zoxide (called from ~/scripts/)
alias nzo="~/scripts/zoxide_openfiles_nvim.sh"

# docker commands
alias dstop='docker stop $(docker ps -aq)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'
alias dimg='docker images'
alias dnet='docker network ls'
alias dps='docker ps -a'
alias dconids='docker ps -aq'

# DevOps tools commands
alias k=kubectl

# View keycodes and attached key to it
keycodes() {
  xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

# Miscellaneous
alias bright='brightnessctl'
