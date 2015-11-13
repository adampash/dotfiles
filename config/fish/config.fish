fish_vi_mode
fish_vi_cursor

set PATH $PATH /Users/aop/.rvm/gems/ruby-2.2.0/bin /Users/aop/.rvm/gems/ruby-2.2.0@global/bin /Users/aop/.rvm/rubies/ruby-2.2.0/bin /usr/local/nvm/versions/node/v4.2.1/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/local/MacGPG2/bin /Users/aop/.rvm/bin /usr/bin /Users/aop/.rvm/bin /Applications/Postgres.app/Contents/Versions/9.4/bin

rvm default


# some nice git shortcuts
alias ga "git add"
alias gc "git commit"
alias gl "git log"

function g
  if count $argv > /dev/null
    git $argv
  else
    git status
  end
end
