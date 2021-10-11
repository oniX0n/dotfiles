# ~/.zprofile
# Profile File runs on login. Environment Variables are set here.

# Adds ~/.local/bin to $PATH
#export PATH="$PATH:$HOME/.local/bin:$HOME/.local/bin/personal"

# Config File clean up
export ZDOTDIR="$HOME/.config/zsh"

# Start X gui with dwm
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  #exec startx &> /dev/null
fi
