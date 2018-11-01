#encoding: utf-8

require 'colored2'
require 'logger'
require 'optparse'

class PodUtility
  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  # initialize for new
  def initialize
    self.cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} [PATH/TO/Podfile] -s symbol1,symbol2,... [options]"
      opts.separator  ""
      opts.separator  "根据指定Podfile，修复同级Pods/Headers/Public下面的软连接问题（development pods添加新的外部使用的.h文件）"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.cmd_options[:verbose] = v
      end

      opts.on("-d", "--development_pods pod1,pod2,...", Array, "included files with ext") do |pod_list|
        self.cmd_options[:development_pods] = pod_list
      end
    end
  end

  def run
    self.cmd_parser.parse!

    if ARGV.length != 1
      puts self.cmd_parser.help
      return false
    end

    development_pods = Array(self.cmd_options[:development_pods])

    if development_pods.empty?
      puts "[Error] use -d to specify at least one development pod.".red
      puts self.cmd_parser.help
      return
    end

    podfile_path = ARGV[0]

    puts podfile_path

  end
end

if !PodUtility.new.run
  return
end

podfile_path = '/Users/wesley_chen/1/TaoMessageBundle/Podfile'
development_pod_name = 'MPMessageContainer'

def target(name)
  if block_given?
    puts name.red
  end

  yield if block_given?
end

def pod(name, *args)
  puts name
  puts *args
end

def platform(type, version)
end

# @param [Hash] hash
def cocoapods_sync_dependencies(hash)
end

load "#{podfile_path}"








