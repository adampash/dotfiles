alias D "cd ~/Downloads"
alias dotfiles "cd ~/dotfiles"
alias vdotfiles "cd ~/dotfiles; vi"
alias reload "source ~/dotfiles/config/fish/config.fish"
alias code "cd ~/code"

function ls
  command ls -lhG $argv
end

function kill_with_port
  set pid (sudo lsof -t -i:$argv)
  echo "Killing process $pid"
  kill $pid
end

function mp3
  youtube-dl --extract-audio --audio-format mp3 $argv
end

function dokku
  command ssh dokku dokku $argv
end

function gawku
  command ssh gawku dokku $argv
end

function ci
  circle $argv
end
