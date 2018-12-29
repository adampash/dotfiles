echo "Sourcing fish"

# Key bindings
fish_vi_key_bindings


set -x PATH "/Users/ap/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)
# status --is-interactive; and . (pyenv shell fish)

set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
source "$HOME/.config/fish/functions/git.fish"
source "$HOME/.config/fish/functions/aliases.fish"

set -x EDITOR nvim
set -U ERL_AFLAGS "-kernel shell_history enabled"

set PATH 'Users/ap/pyenv/shims' $PATH
set PYENV_SHELL fish

# set -gx SSL_CERT_FILE /usr/local/heroku/data/cacert.pem

set PATH $PATH /usr/local/nvm/versions/node/v4.2.1/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/local/MacGPG2/bin /usr/bin /Applications/Postgres.app/Contents/Versions/9.5/bin
set PATH /usr/local/bin $PATH

# rbenv ruby version manager
status --is-interactive
and . (rbenv init -|psub)

# nvm node version manager
test -s /Users/ap/.nvm-fish/nvm.fish
and source /Users/ap/.nvm-fish/nvm.fish

eval (direnv hook fish)

eval (python -m virtualfish)

# eval (python -m virtualfish compat_aliases)

# test -e {$HOME}/.iterm2_shell_integration.fish
# and source {$HOME}/.iterm2_shell_integration.fish

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
# [ -f /Users/aop/.nvm/versions/node/v4.3.2/lib/node_modules/yarn-completions/node_modules/tabtab/.completions/yarn.fish ]
# and . /Users/aop/.nvm/versions/node/v4.3.2/lib/node_modules/yarn-completions/node_modules/tabtab/.completions/yarn.fish

export GOPATH="$HOME/code/gopath/"
set PATH $PATH $GOPATH/bin
# Set yarn bin
set PATH $PATH $HOME/.config/yarn/global/node_modules/.bin
# Set rust bin
export RUSTPATH="$HOME/.cargo/"
set PATH $PATH $RUSTPATH/bin
# Set yarn bin

# Set rvm default as default ruby
# rvm default

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/aop/code/postlight/internal/read/analytics/cloudwatch-to-lambda/node_modules/tabtab/.completions/serverless.fish ]
and . /Users/aop/code/postlight/internal/read/analytics/cloudwatch-to-lambda/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/aop/code/postlight/internal/read/analytics/cloudwatch-to-lambda/node_modules/tabtab/.completions/sls.fish ]
and . /Users/aop/code/postlight/internal/read/analytics/cloudwatch-to-lambda/node_modules/tabtab/.completions/sls.fish
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc' ]
#     if type source >/dev/null
#         source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'
#     else
#         . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc'
#     end
# end
source ~/.asdf/asdf.fish
