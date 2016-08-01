function fish_user_key_bindings
  fish_vi_key_bindings
  # accept autocomplete suggestion with ctr+]
  bind -M insert \c] accept-autosuggestion
end
