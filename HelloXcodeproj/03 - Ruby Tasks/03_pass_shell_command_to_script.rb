#!/usr/bin/env ruby
# 
# 
# Usage:
#   ruby 03_pass_shell_command_to_script.rb ruby callee.rb
#   ./03_pass_shell_command_to_script.rb ruby callee.rb
#
# Demo ouput:
#   execute `ruby callee.rb` command
# 
# Reference:
#   @see https://www.ruby-forum.com/topic/193088
#   @see https://stackoverflow.com/questions/9351539/is-it-possible-to-export-environment-property-from-ruby-script

ENV['develop_pod_mode']='YES'
system(ARGV.join(' '))