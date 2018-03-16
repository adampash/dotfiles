function vi
  if count $argv > /dev/null
    nvim $argv
  else
    nvim -S
  end
end


