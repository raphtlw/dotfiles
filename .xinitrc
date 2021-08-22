eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

nvidia-settings --load-config-only
