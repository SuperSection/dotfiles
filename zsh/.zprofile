# XDG fix
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$XDG_DATA_DIRS"

# Start ssh agent (once)
eval $(keychain --quiet --eval ~/.ssh/gitlab)

