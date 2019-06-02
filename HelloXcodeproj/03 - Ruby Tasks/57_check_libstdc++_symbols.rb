#encoding: utf-8

require 'yaml'
require 'optparse'
require 'colored2'
require 'json'
require_relative '../02 - Ruby Helper/rubyscript_helper'

class NmUtility
  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  def initialize
    self.cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} PATH/TO/static_library"
      opts.separator  ""
      opts.separator  "检查某个静态库是否使用到libstdc++符号"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.cmd_options[:verbose] = v
      end

      opts.on("-dPATH", "--dump-file=PATH", "Dump to json file") do |v|
        self.cmd_options[:dump_file_path] = v
      end

      opts.on("-D", "--[no-]demangle", "Demangle C++ symbols") do |v|
        self.cmd_options[:demangle] = v
      end

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
    if !static_lib_path
      puts self.cmd_parser.help
      return
    end

    return_value = `nm -j #{static_lib_path}`
    result = $?.success?
    if !result
      puts "execute `nm -j #{static_lib_path}` failed"
      return
    end

    # @see https://stackoverflow.com/a/3877355
    yaml_object = YAML.load_file('./57_samples/libstdc++.6.0.9.tbd')

    if (not self.cmd_options[:dump_file_path].nil?) and (not self.cmd_options[:dump_file_path].empty?)
      File.open("#{self.cmd_options[:dump_file_path]}","w") do |f|
        f.write(yaml_object.to_json)
      end
    end

    all_symbols_list = []

    yaml_object["exports"].each do |element|
      all_symbols_list += element["symbols"]
      all_symbols_list += element["weak-def-symbols"]
    end

    # puts all_symbols_list

    object_symbol_map = {}

    object_sections = return_value.split("\n\n")
    object_sections.each do |section|
      parts = section.split(":\n")
      if parts.count != 2
        puts "[Warning] #{section} has no symbols".yellow
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
      intersection = all_symbols_list & symbols

      # @see https://stackoverflow.com/a/2603904
      if not intersection.empty?
        puts object_name + ":\n"
        intersection.sort.each do |symbol|
          if self.cmd_options[:demangle] == true
            puts `c++filt #{symbol}`
          else
            puts symbol + "\n"
          end
        end
        puts "\n"
      end
    end

  end
end

NmUtility.new.run
