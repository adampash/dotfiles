function fish_mode_prompt
  if set -q __fish_vi_key_bindings
    switch $fish_bind_mode
      case default
        set_color --bold --background normal green
        echo '●'
      case insert
        set_color --bold --background normal blue
        echo '●'
      case replace-one
        set_color --bold --background normal green
        echo '●'
      case visual
        set_color --bold --background normal magenta
        echo '●'
    end
    set_color normal
    echo -n ' '
  end
end

