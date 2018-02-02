#encoding: utf-8

require 'optparse'

class NmUtility

  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  # initialize for new
  def initialize
    self.cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} PATH/TO/FOLDER -s symbol_list [options]"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.cmd_options[:verbose] = v
      end

      opts.on("-i", "--include_exts suffix1,suffix2,...", Array, "included files with ext") do |include_list|
        self.cmd_options[:include_list] = include_list
      end

      opts.on("-e", "--exclude_exts suffix1,suffix2,...", Array, "excluded files with ext") do |exclude_list|
        self.cmd_options[:exclude_list] = exclude_list
      end

      opts.on("-s", "--symbol_list symbol1,symbol2,...", Array, "the symbol to search") do |symbol_list|
        self.cmd_options[:symbol_list] = symbol_list
      end
    end
  end

  # parse command line
  def run
    self.cmd_parser.parse!

    if ARGV.length != 1
      puts self.cmd_parser.help
      return
    end

    # @see https://stackoverflow.com/questions/1541294/how-do-you-specify-a-required-switch-not-argument-with-ruby-optionparser/1542658#1542658
    symbol_list = Array(self.cmd_options[:symbol_list])

    if symbol_list.empty?
      puts "[Error] use -s to specify at least one symbol."
      puts self.cmd_parser.help
      return
    end

    dir_path = ARGV[0]

    include_list = Array(self.cmd_options[:include_list])
    exclude_list = Array(self.cmd_options[:exclude_list])
    verbose = self.cmd_options[:verbose]

    if !File.directory?(dir_path)
      puts "[Error] #{dir_path} is not a directory!"
      return
    end

    Dir.glob(dir_path + '/**/*') do |item|
      next if item == '.' or item == '..'

      if !File.directory?(item) && File.exist?(item)

        # @see https://stackoverflow.com/questions/16902083/exclude-the-from-a-file-extension-in-rails
        file_ext = File.extname(item).delete('.')
        if !exclude_list.empty? and exclude_list.include?(file_ext)
          next
        end

        if include_list.include?(file_ext) or file_ext == ''

          # Note: lookup symbols for every file
          symbol_list.each do |symbol|
            if verbose
              puts "nm -m #{item} 2>/dev/null | grep #{symbol}"
            end

            `nm -m #{item} 2>/dev/null | grep #{symbol}`
            result = $?.success?

            if (result)
              puts "Find symbol #{symbol} in #{item}"
            end
          end

        end
      end
    end

  end
end

NmUtility.new.run
