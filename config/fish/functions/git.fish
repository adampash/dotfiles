# some nice git shortcuts
alias ga "git add"
alias gc "git commit"
alias gl "git log"
alias gb "git branch"

function g
  if count $argv > /dev/null
    git $argv
  else
    git status
  end
end

function gh
  open (git remote -v | grep origin | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//' | head -n1)
end
