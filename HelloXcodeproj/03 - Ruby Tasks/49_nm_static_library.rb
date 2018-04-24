require_relative '../02 - Ruby Helper/rubyscript_helper'
require 'optparse'

class NmUtility
  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  def initialize
    self.cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} PATH/TO/static_library"
      opts.separator  ""
      opts.separator  "nm排序结果"

      # opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      #   self.cmd_options[:verbose] = v
      # end
      #
      # opts.on("-i", "--include_exts suffix1,suffix2,...", Array, "included files with ext") do |include_list|
      #   self.cmd_options[:include_list] = include_list
      # end
      #
      # opts.on("-e", "--exclude_exts suffix1,suffix2,...", Array, "excluded files with ext") do |exclude_list|
      #   self.cmd_options[:exclude_list] = exclude_list
      # end
      #
      # opts.on("-s", "--symbol_list symbol1,symbol2,...", Array, "the symbols to search") do |symbol_list|
      #   self.cmd_options[:symbol_list] = symbol_list
      # end
    end
  end

  def run
    self.cmd_parser.parse!
    # dump_object(ARGV[0])

    static_lib_path = ARGV[0]

    return_value = `nm -j #{static_lib_path}`
    result = $?.success?
    if !result
      puts "execute `nm -j #{static_lib_path}` failed"
      return
    end

    object_symbol_map = {}

    object_sections = return_value.split("\n\n")
    object_sections.each do |section|
      parts = section.split(":\n")
      if parts.count != 2
        puts "number of parts is not 2, please check #{section}"
        next
      end

      # @see https://stackoverflow.com/a/4115144
      object_name = parts[0][/\((.*\.o)\)/, 1]
      symbols = parts[1].split("\n").sort!

      # dump_object(object_name)
      # dump_object(symbols)

      object_symbol_map[object_name] = symbols
    end

    # dump_object(object_symbol_map)

    object_symbol_map.sort.to_h.each do |object_name, symbols|
      puts object_name + ":\n"
      symbols.sort.each do |symbol|
        puts symbol + "\n"
      end
      puts "\n"
    end

  end
end

NmUtility.new.run
