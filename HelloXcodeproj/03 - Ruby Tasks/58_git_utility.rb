#encoding: utf-8
#
#

require 'optparse'

# @param [Object]  test
# @param [Integer]  num
# @param [Array]  several_variants
# @param [Hash]  new
# @return [Object]
def encode!(test, num = 1, *several_variants, **new)

end

class GitUtility
  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  def initialize
    self.cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} PATH/TO/git repo"
      opts.separator  ""
      opts.separator  "git帮助工具"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.cmd_options[:verbose] = v
      end


    end
  end
end