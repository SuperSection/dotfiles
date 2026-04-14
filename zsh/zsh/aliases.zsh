

# -----------------------------------------------------
# General Commands
# -----------------------------------------------------
alias ..='cd ..'
alias v='$EDITOR'
alias vim='nvim'
alias c='clear'
alias x='exit'
alias lg='lazygit'
alias wifi='nmtui'

# ls commands
alias ls='ls --color -p'
alias la='ls -a'
alias ll='ls -alh'
alias lu='ls -alu' # shows last Access time
alias lc='ls -alc' # shows last Change time

# eza commands
alias eza='eza -a --icons=always'
alias ezal='eza -l'
alias ezat='eza --tree --level=1'

# system commands
alias poweroff='sudo systemctl poweroff'
alias suspend='sudo systemctl suspend'
alias reboot='sudo systemctl reboot'

# windows mount
alias C='cd /mnt/windows_C'
alias D='cd /mnt/windows_D'

# config
alias arch-cleanup='~/.config/supersection/scripts/supersection-arch-cleanup'
alias apps='~/.config/supersection/bin/supersection-apps'
alias screenshot='~/.config/supersection/bin/supersection-screenshot'
alias updates='~/.config/supersection/scripts/supersection-install-system-updates'
alias filemanager='~/.config/supersection/settings/filemanager'
alias lock='hyprlock'
alias clock='tty-clock'
alias system='~/.config/supersection/settings/systemmonitor'
alias quick='~/.config/supersection/bin/supersection-quicklinks'
alias wallpaper='~/.config/supersection/bin/supersection-wallpaper'
alias settings='supersection-dotfiles-settings com.supersection.dotfiles'


# -----------------------------------------------------
# SuperSection Apps
# -----------------------------------------------------
alias supersection='qs ipc call welcome toggle'
alias supersection-settings='qs -p ~/.local/share/supersection-dotfiles-settings/quickshell ipc call settings toggle'
alias supersection-calendar='qs ipc call calendar toggle'
alias supersection-hyprland='flatpak run com.supersection.hyprlandsettings'
alias supersection-sidebar='qs ipc call sidebar toggle'


# -----------------------------------------------------
# Git Commands
# -----------------------------------------------------
alias ginit='git init'
alias ga='git add'
alias gc='git commit -m'
alias gcom='git add --all && git commit -m'
alias grao='git remote add origin'
alias gs='git status -s'
alias glog='git log'
alias gl='git log --oneline --graph --all'
alias gb='git branch'
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gcheck='git checkout'
alias gcredential="git config credential.helper store"

# -----------------------------------------------------
# Tmux Commands
# -----------------------------------------------------
alias tnew='tmux new -s'
alias tat='tmux attach -t'
alias td='tmux detach'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'


# -----------------------------------------------------
# Scripts
# -----------------------------------------------------
alias ascii='~/.config/supersection/scripts/supersection-ascii-header'

# calls the tmux new session script
alias tns="~/scripts/tmux-sessionizer"

# fzf 
# called from ~/scripts/
alias nlof="~/scripts/fzf_listoldfiles.sh"
# opens documentation through fzf (eg: git,zsh etc.)
alias fman="compgen -c | fzf | xargs man"

# zoxide (called from ~/scripts/)
alias nzo="~/scripts/zoxide_openfiles_nvim.sh"


# -----------------------------------------------------
# Docker Commands
# -----------------------------------------------------
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


# -----------------------------------------------------
# System
# -----------------------------------------------------
update-grub() {
  echo "Updating GRUB config..."
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}
