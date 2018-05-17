require_relative '../02 - Ruby Helper/rubyscript_helper'
require 'optparse'

class DirUtility
  attr_accessor :cmd_parser
  attr_accessor :cmd_options
  attr_accessor :subcmd_parsers

  # CONFIGURE: define more subcommands here
  SUBCMD_ALIAS = 'alias'

  def initialize

    self.cmd_options = {}

    self.subcmd_parsers = {
        # CONFIGURE: add OptionParser for more subcommands
        SUBCMD_ALIAS => OptionParser.new do |opts|
          # init options for subcommand
          self.cmd_options[SUBCMD_ALIAS] = {}

          description = 'Deal with alias files under specific folder'
          self.cmd_options[SUBCMD_ALIAS][:description] = description

          summary = <<HELP
#{description}
HELP

          opts.banner = "Usage: #{__FILE__} #{SUBCMD_ALIAS} [-c | -k | -l] dir_path"
          opts.separator  ""
          opts.separator  summary

          opts.on("-c", "--clean", "Clean up invalid alias files") do |v|
            self.cmd_options[SUBCMD_ALIAS][:clean] = v
          end

          opts.on("-k", "--check", "check all alias files if valid") do |v|
            self.cmd_options[SUBCMD_ALIAS][:check] = v
          end

          opts.on("-l", "--list", "list all alias files") do |v|
            self.cmd_options[SUBCMD_ALIAS][:list] = v
          end
        end
    }


    self.cmd_parser = OptionParser.new do |opts|

      subcommands_summary = ""
      self.subcmd_parsers.keys.each do |subcommand|
        description = self.cmd_options[subcommand][:description]
        subcommands_summary += "   #{subcommand} :  #{description}\n"
      end

      help = <<HELP
subcommands are:
#{subcommands_summary}
See '#{__FILE__} SUBCOMMAND --help' for more information on a specific subcommand.
HELP

      opts.banner = "Usage: #{__FILE__} [options] [subcommand [options]]"
      opts.separator  ""
      opts.separator  help

      # Note: `on_head` let option tips after banner
      opts.on_head("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.cmd_options[:verbose] = v
      end
    end

  end

  def handle_subcommand_alias(subcommand)
    subcmd_parser = self.subcmd_parsers[subcommand]
    subcmd_options = self.cmd_options[subcommand]
    if ARGV[0].nil? or subcmd_options.length == 1
      puts subcmd_parser.help()
      return
    end

    dir_path = ARGV[0]
    list_alias = subcmd_options[:list] || false
    delete_invalid_alias = subcmd_options[:clean] || false
    check_alias = subcmd_options[:check] || false

    if list_alias
      puts "All alias files are:"
    elsif check_alias
      puts "All broken alias files are:"
    elsif delete_invalid_alias
      puts "Delete all broken alias files:"
    end

    Dir.glob(dir_path + '/*').sort.each do |path|
      next if path == '.' or path == '..'

      symlink = File.symlink?(path)
      exist = File.exist?(path)

      next if not symlink

      if list_alias
        puts "#{path}"
      elsif check_alias
        if !exist
          puts "#{path}"
        end
      elsif delete_invalid_alias
        if !exist
          puts "Deleting #{path}"
          File.delete(path)
        end
      end
    end



  end

  def run
    self.cmd_parser.order!
    # get the first parameter as subcommand
    subcommand = ARGV.shift

    # check subcommand if has parser
    if subcommand.nil? or self.subcmd_parsers[subcommand].nil?
      puts self.cmd_parser.help()
      return
    end

    self.subcmd_parsers[subcommand].parse!

    # @see https://stackoverflow.com/a/948157
    case subcommand
      when SUBCMD_ALIAS
        self.handle_subcommand_alias(subcommand)
    end
  end
end

DirUtility.new.run
