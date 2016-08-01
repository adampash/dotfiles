set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
# source $fisher_home/config.fish
source "$HOME/.config/fish/functions/git.fish"
. "$HOME/.config/fish/functions/aliases.fish"
. "$HOME/.config/fish/functions/fish_user_key_bindings.fish"

# set -gx SSL_CERT_FILE /usr/local/heroku/data/cacert.pem

set PATH $PATH /Users/aop/.rvm/gems/ruby-2.2.0/bin /Users/aop/.rvm/gems/ruby-2.2.0@global/bin /Users/aop/.rvm/rubies/ruby-2.2.0/bin /usr/local/nvm/versions/node/v4.2.1/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/local/MacGPG2/bin /Users/aop/.rvm/bin /usr/bin /Users/aop/.rvm/bin /Applications/Postgres.app/Contents/Versions/9.4/bin

# rvm default

# rbenv
status --is-interactive; and . (rbenv init -|psub)


test -s /Users/ap/.nvm-fish/nvm.fish; and source /Users/ap/.nvm-fish/nvm.fish

eval (direnv hook fish)

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
