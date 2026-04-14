# XDG fix
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$XDG_DATA_DIRS"

# Start ssh agent (once)
eval $(keychain --quiet --eval ~/.ssh/gitlab)

# Start tmux server once
if ! pgrep -x "tmux" >/dev/null; then
  tmux start-server
fi
