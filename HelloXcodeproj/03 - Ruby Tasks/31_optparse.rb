#encoding: utf-8

require 'optparse'

# @see https://ruby-doc.org/stdlib-2.1.1/libdoc/optparse/rdoc/OptionParser.html
# @see https://stelfox.net/blog/2012/12/rubys-option-parser-a-more-complete-example/
# @see http://rubylearning.com/blog/2011/01/03/how-do-i-make-a-command-line-tool-in-ruby/

options = {}
OptionParser.new do |opts|
  # Note: prompts
  opts.banner = "Usage: opt_parser COMMAND [OPTIONS]"
  opts.separator  ""
  opts.separator  "Commands"
  opts.separator  "     start: start server"
  opts.separator  "     stop: stop server"
  opts.separator  "     restart: restart server"
  opts.separator  ""
  opts.separator  "Options"

  # Note: take a switch of opts
  # true => -v/--verbose
  # false => --no-verbose
  # nil => <not present>
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  # Note: take a list of opts (must have a opt at least)
  opts.on("-l", "--list x,y", Array,
          "This command flag takes a comma separated list (without",
          "spaces) of values and turns it into an array. This requires",
          "at least one argument.") do |v|
    options[:list] = v
  end

  # Mandatory argument.
  opts.on("-r", "--require LIBRARY",
          "Require the LIBRARY before executing your script") do |lib|
    options[:library] << lib
  end

  opts.on("-nNAME", "--name=NAME", "Name to say hello to") do |n|
    options[:name] = n
  end

end.parse!

# Note: get options
p options[:verbose]
p options[:list]

puts "Get all options:"
p options
puts "\n"

puts "Get all arguments:"
# Note: get arguments
p ARGV
puts "\n"

p ARGV[0]

p __FILE__
