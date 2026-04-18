# Use less with raw color support
export MANPAGER="less -R"

# Better LESS defaults
export LESS='-R --mouse --wheel-lines=3'

export GROFF_NO_SGR=1   # For Konsole and Gnome-terminal

# ---- COLORS ----

# Bold (section headers like NAME, SYNOPSIS)
export LESS_TERMCAP_md=$'\e[1;38;5;203m'   # soft red
export LESS_TERMCAP_mb=$'\e[1;38;5;203m'

# Reset
export LESS_TERMCAP_me=$'\e[0m'

# Underline (commands, arguments)
export LESS_TERMCAP_us=$'\e[4;1;32m'   # green + underline
export LESS_TERMCAP_ue=$'\e[0m'

# Standout (search highlight)
export LESS_TERMCAP_so=$'\e[1;38;5;226;48;5;236m'  # yellow on dark gray
export LESS_TERMCAP_se=$'\e[0m'

# Reverse (rare)
export LESS_TERMCAP_mr=$'\e[7m'

# Dim text
export LESS_TERMCAP_mh=$'\e[2m'

# Optional (rarely used, safe to keep)
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'

# For all using Arch try export MANROFFOPT='-c' this activates Overstrike
export MANROFFOPT='-c'
