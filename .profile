#!/bin/sh

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

export PATH="$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.npm-global/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"
export DOMAIN=local
export TSC_WATCHFILE=UseFsEvents
