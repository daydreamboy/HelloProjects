#encoding: utf-8

require 'optparse'
require 'open3'

class CodesignUtility

  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  # initialize for new
  def initialize
    @cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} PATH/TO/XXX.app"
      opts.separator  ""
      opts.separator  "在指定xxx.app/Frameworks下面的framework有效性"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        @cmd_options[:verbose] = v
      end
    end
  end

  def logV(msg)
    if (@cmd_options[:verbose])
      puts "[Verbose] #{msg}"
    end
  end

  # parse command line
  def run
    @cmd_parser.parse!

    if ARGV.length != 1
      puts @cmd_parser.help
      return
    end

    app_path = ARGV[0]

    if !File.directory?(app_path)
      puts "[Error] #{app_path} is not a directory!"
      return
    end

    invalid_framework = nil
    Dir.glob(app_path + '/Frameworks/*') do |item|
      next if item == '.' or item == '..'

      if File.directory?(item) && File.exist?(item) && File.extname(item) == '.framework'
        logV("codesign -vv #{item}")

        # @see http://blog.honeybadger.io/capturing-stdout-stderr-from-shell-commands-via-ruby/
        stdout, stderr, status = Open3.capture3("codesign -vv #{item}")

        if (!status.success?)
          errMsg = stderr
          errMsg.slice!(item)
          invalid_framework = File.basename(item)
          puts "#{invalid_framework}#{errMsg}"
          if (stdout)
            puts "Maybe caused by #{stdout}"
          end
          break
        end
      end
    end

    if (!invalid_framework)
      puts "frameworks are all valid!"
    end

  end
end

CodesignUtility.new.run
