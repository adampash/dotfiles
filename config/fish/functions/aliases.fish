alias D "cd ~/Downloads"
alias dotfiles "cd ~/dotfiles"
alias vdotfiles "cd ~/dotfiles; vi"
alias reload "source ~/dotfiles/config/fish/config.fish"
alias db "cd ~/Dropbox"
alias labs "cd ~/code/labs"
alias code "cd ~/code"

function ls
  command ls -lahG $argv
end


function new_interactive
  git clone git@github.com:adampash/react-redux-static-boilerplate.git
  mv react-redux-static-boilerplate $argv
  cd $argv
  rm -rf .git
  git init
  git add .
  git commit -m "initial commit"
end
