# some nice git shortcuts
alias gc "git commit"
alias gl "git log"
alias gb "git branch"
alias gd "git diff"

function g
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
      open (git remote -v | grep origin | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//' | head -n1)
    else
      new_github
    end
  else
    echo "Initializing git repository"
    git init
    new_github
  end
end

function new_github
  echo "Creating github repo"
  hub create
end
