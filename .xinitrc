#!/bin/sh

# init keyring
eval $(/usr/bin/gnome-keyring-daemon --start --daemonize --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

nvidia-settings --load-config-only

export LIBVIRT_DEFAULT_URI=qemu:///system

exec i3
