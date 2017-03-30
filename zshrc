# Load zsh-syntax-highlighting.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# use zsh plugins
plugins=(git sudo bundler osx rake ruby aws cp emoji gem heroku tmux)

# load our own completion functions
fpath=(~/.zsh/completion $fpath)
# completion
autoload -U compinit
compinit

for function in ~/.zsh/functions/*; do
  source $function
done

# automatically enter directories without cd /// removed b/c annoying
# setopt auto_cd

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode
bindkey jj vi-cmd-mode

# use incremental search
bindkey "^R" history-incremental-search-backward

# add some readline keys back
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# handy keybindings
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# expand functions in the prompt
setopt prompt_subst

# prompt
export PS1='[${SSH_CONNECTION+"%n@%m:"}%~] '

# ignore duplicate history entries
setopt histignoredups

# keep TONS of history
export HISTSIZE=4096

# look for ey config in project dirs
export EYRC=./.eyrc

# automatically pushd
setopt auto_pushd
export dirstacksize=5

# awesome cd movements from zshkit
setopt AUTOCD
setopt AUTOPUSHD PUSHDMINUS PUSHDSILENT PUSHDTOHOME
setopt cdablevars

# Try to correct command line spelling
setopt CORRECT

# Enable extended globbing
setopt EXTENDED_GLOB

# Allow [ or ] whereever you want
unsetopt nomatch

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# set NACL_SDK_ROOT for Native Client
NACL_SDK_ROOT=$HOME/SDKs/nacl/pepper_31

# set ANDROID_HOME for react-native
export ANDROID_HOME=/usr/local/opt/android-sdk

# set emscripten SDK path
PATH=$PATH:$HOME/SDKs/emscripten/emsdk_portable

# set yarn path
PATH=$PATH:$(yarn global bin)


# set newer git path
PATH=/usr/local/git/bin:$PATH
PATH=$PATH:/usr/bin

# path for local npm
PATH=$PATH:$HOME/npm/bin

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# PATH=$PATH:$HOME:/usr/local/depot_tools # Add depot_tools for gclient

export NVM_DIR="/Users/ap/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
