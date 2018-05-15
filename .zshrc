#!/bin/zsh

mkcd ()
{
	mkdir -p -- "$1" &&
		cd -P -- "$1"
}

# Set up aliases for exa (ls replacement)
alias -g k='exa -bla --color-scale'
alias -g kk='exa -a'
alias -g kg='exa -bla --git --color-scale'

urldecode(){
  echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x\1/g;')"
}

# Store History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history



# VI MODE
# -------
bindkey -v

# Set Vi mode switch delay to 0.1 seconds
export KEYTIMEOUT=1

# Keep Ctrl+{N,P} working
bindkey '^P' up-history
bindkey '^N' down-history

# Keep backspace and Ctrl+h working
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# Fix Perl language errors
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

autoload -U promptinit
promptinit



# ZPLUG
# -----
export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

# Base
zplug "b4b4r07/zplug"

# Navigation and searching
zplug "plugins/fasd", \
      from:oh-my-zsh
zplug "mollifier/anyframe"
zplug "b4b4r07/enhancd", use:init.sh

# Better command-entering
zplug "zsh-users/zsh-completions"

# UI
zplug "nojhan/liquidprompt" # prompt
# Niceness makes this load later
zplug "zsh-users/zsh-syntax-highlighting", defer:1

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

test -e "$HOME/.asdf/asdf.sh" && source "$HOME/.asdf/asdf.sh"
test -e "$HOME/.asdf/completions/asdf.bash" && source "$HOME/.asdf/completions/asdf.bash"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/dev/torch/install/bin/torch-activate" && source "${HOME}/dev/torch/install/bin/torch-activate"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Base16 via base16-manager
test -e "${HOME}/.base16_theme" && source "${HOME}/.base16_theme"

if type python3.6 > /dev/null; then
  alias python=python3.6
  alias python3=python3.6
fi

_FZF_BINDINGS_FILE="/usr/share/fzf/shell/key-bindings.zsh"
test -e $_FZF_BINDINGS_FILE && source $_FZF_BINDINGS_FILE
[ -f ~/.fzf.colors ] && source ~/.fzf.colors
