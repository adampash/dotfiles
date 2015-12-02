default_command_set = Pry::CommandSet.new do
  command "clear" do
    system 'clear'
  end
end

Pry.config.commands.import default_command_set
