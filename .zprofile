# ~/.zprofile
# Profile File runs on login. Environment Variables are set here.


# Adds ~/.local/bin to $PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.ghcup/bin"

# Config File clean up
export ZDOTDIR="$HOME/.config/zsh"

# Start X gui with dwm
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  # exec startx $HOME/.config/xinit/xinitrc &> /dev/null
	  exec niri-session
fi
