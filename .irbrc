# Dependancies
# gem install wirble

# Interactive Ruby console configuration

# Load RubyGems in Irb
begin
  require 'rubygems'
rescue LoadError => err
  warn "Couldn't load RubyGems: #{err}"
end


begin
  # Load and initialize wirble
  require 'wirble'
  Wirble.init(:skip_prompt => true, :skip_history => true)
  # Enable Wirble colors
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end
