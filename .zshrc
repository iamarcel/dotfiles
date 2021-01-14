#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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
# zplug "mollifier/anyframe"
zplug "b4b4r07/enhancd", use:init.sh

# Better command-entering
zplug "zsh-users/zsh-completions"

# UI
# zplug "nojhan/liquidprompt" # prompt
zplug romkatv/powerlevel10k, as:theme, depth:1

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

export PATH="$HOME/.emacs.d/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Base16 via base16-manager
test -e "${HOME}/.base16_theme" && source "${HOME}/.base16_theme"

if type python3.6 > /dev/null; then
  alias python=python3.6
  alias python3=python3.6
fi

_FZF_BINDINGS_FILE="/usr/share/fzf/shell/key-bindings.zsh"
test -e $_FZF_BINDINGS_FILE && source $_FZF_BINDINGS_FILE
[ -f ~/.fzf.colors ] && source ~/.fzf.colors

# GPG FOR SSH
# -----------

if command -v gpgconf &> /dev/null
then
	export SSL_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
	gpgconf --launch gpg-agent
fi

export CC=$(which clang)
export CXX=$(which clang++)

# SHORTCUTS
# ---------

export ZEC_HOME="$HOME/code/zec"
alias zsn="\cd $ZEC_HOME/SilverNode"
alias zsnb="\cd $ZEC_HOME/SilverNode/build"
alias znr="\cd $ZEC_HOME/NeonRAW"
alias znui="\cd $ZEC_HOME/nui"
alias zcol="\cd $ZEC_HOME/color"

gpzec(){
  for REPO in $(ls "$ZEC_HOME/")
  do
    if [ -d "$ZEC_HOME/$REPO" ]
    then
      echo "---"
      echo "--- Updating $ZEC_HOME/$REPO"
      if [ -d "$ZEC_HOME/$REPO/.git" ]
      then
        cd "$ZEC_HOME/$REPO"
        git status
        git pull
      else
        echo "--- Skipping because it doesn't look like it has a .git folder."
      fi
    fi
  done
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval $(thefuck --alias)

export TSC_NONPOLLING_WATCHER=true
export TSC_WATCHFILE=UseFsEventsWithFallbackDynamicPolling
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="~/.npm-global/bin:$PATH"
export PATH="/Users/marcel/Library/Python/3.9/bin:$PATH"
