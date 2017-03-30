function prettier
  if test -e ./node_modules/.bin/prettier
    ./node_modules/.bin/prettier $argv
  else
    set path (yarn global bin)
    eval $path/prettier $argv
  end
end

