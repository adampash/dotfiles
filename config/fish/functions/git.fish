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
      echo "No matching remote"
    end
  else
    echo "No .git repo here; trying parent"
    cd ..; and gh
  end
end

function pr-flow
  echo "Pushing branch and creating PR"
  git push; and git pull-request; and watch-and-open
end

function watch-and-open
  echo "Watching CI"
  if circle --watch
    gh
  else
    circle open
  end
end
