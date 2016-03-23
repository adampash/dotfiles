alias D "cd ~/Downloads"
alias dotfiles "cd ~/dotfiles"
alias vdotfiles "cd ~/dotfiles; vi"
alias reload "source ~/dotfiles/config/fish/config.fish"
alias db "cd ~/Dropbox"
alias labs "cd ~/code/labs"
alias code "cd ~/code"

function ls
  command ls -lhG $argv
end

function new_interactive
  git clone git@github.com:adampash/react-redux-static-boilerplate.git
  mv react-redux-static-boilerplate $argv
  cd $argv
  rm -rf .git
  git init
  git add .
  git commit -m "initial commit"
  npm install
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
