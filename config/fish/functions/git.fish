# some nice git shortcuts
alias git "hub"
alias gc "git commit"
alias gl "git log"
alias gb "git branch"
alias gd "git diff"
alias gpr "git pull-request"

function g --wraps git
  if count $argv > /dev/null
    git $argv
  else
    git status
  end
end

function ga
  if count $argv > /dev/null
    git add $argv
  else
    git add .
  end
end

function gh
  if test -d .git
    # set remote (git remote -v)
    if git remote -v | grep github.com
      echo "Opening github repo"
      hub browse
    else
      new_github
    end
  else
    echo "Initializing git repository"
    git init
    new_github
  end
end

function watch_and_open
  echo "Watching CI"
  circle --watch; and gh
end

function new_github
  echo "Creating github repo"
  hub create
end
