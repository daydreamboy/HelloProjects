# This file provide convenient methods
#
# Usage:
#   require_relative '../02 - Ruby Helper/rubyscript_helper'
#
# References:
#   https://stackoverflow.com/questions/16856243/how-to-require-a-ruby-file-from-another-directory

require 'logger'
require 'colored2'

# 1. Dump object
#
# Demo output:
# [Debug] test_dump_object.rb:8: string = (String) "hello, world"
# [Debug] test_dump_object.rb:9: dict = (Hash) {}
# [Debug] test_dump_object.rb:10: array = (Array) []
# [Debug] test_dump_object.rb:11: number = (Integer) 3
# [Debug] test_dump_object.rb:13: "string" = (String) "string"
# [Debug] test_dump_object.rb:14: {} = (Hash) {}
# [Debug] test_dump_object.rb:15: [1, 2, 3] = (Array) [1, 2, 3]
# [Debug] test_dump_object.rb:16: 3.14 = (Float) 3.14
#
# @see https://stackoverflow.com/questions/15769739/determining-type-of-an-object-in-ruby
# @see https://stackoverflow.com/questions/41032717/get-original-variable-name-from-function-in-ruby
# @see https://stackoverflow.com/questions/3453262/how-to-strip-leading-and-trailing-quote-from-string-in-ruby
# @see http://ruby-doc.org/core-2.1.0/Regexp.html
#
# /<.+>/.match("<a><b>")  #=> #<MatchData "<a><b>">
# /<.+?>/.match("<a><b>") #=> #<MatchData "<a>">
#
def dump_object(arg)
  loc = caller_locations.first
  line = File.read(loc.path).lines[loc.lineno - 1]

  # get string started by `dump_object`
  callerString = line[/#{__method__}\(.+\)/].to_s

  # get parameter name of `dump_object`
  argName = callerString[/\(.+\)/]

  # get content of parenthesis
  argNameStr = argName.gsub!(/^\(|\)?$/, '')

  filename = loc.path
  lineNo = loc.lineno

  puts "[Debug] #{filename}:#{lineNo}: #{argNameStr} = (#{arg.class}) #{arg.inspect}"
end

# 2. A class for logging message on diferrent level
# 
# Usage:
#   Log.i, Log.d, Log.e, Log.w
#
# Demo:
#   Log.w('This is a warning')
# 
# Reference:
#   @see none
class Log
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::DEBUG

  def self.i(msg)
    # @@logger.info(msg)
    puts msg
  end

  def self.d(msg)
    # @@logger.debug(msg)
    puts msg.blue
  end

  def self.w(msg)
    # @@logger.warn(msg)
    puts msg.yellow
  end

  def self.e(msg)
    # @@logger.error(msg)
    puts msg.red
  end
end

class Collection
  # Merge two hash
  #
  # @param  [Hash] hash1
  # @param  [Hash] hash2
  # @param  [Hash] merge_connector_info
  #         the specific connectors to concatenate value for keys. (Only for Strings)
  #
  def self.merge_hash(hash1, hash2, merge_connector_info = nil)
    hash = hash1.dup

    # hash2 => hash
    hash2.each do |k, v|
      if hash.has_key?(k)
        if v.is_a?(Hash)
          # value是Hash，递归合并
          hash[k] = merge_hash(hash[k], v)
        elsif v.is_a?(Array)
          # value是Array，不检查元素是否还是Array，直接合并去重
          hash[k] = (hash[k] + v).uniq
        elsif v.is_a?(String) && !v.eql?(hash[k])
          # value是String，检查是否相同，相同不合并，不相同合并而且用空格连接

          if merge_connector_info.nil?
            hash[k] = hash[k] + ' ' + v
          else
            if merge_connector_info[k].nil?
              hash[k] = hash[k] + ' ' + v
            else
              # 指定特定key对应value的连接符，则不使用空格
              hash[k] = hash[k] + merge_connector_info[k] + v
            end
          end

        else
          # value是其他类型（非Hash、Array、String），则忽略
        end
      else
        hash[k] = v
      end
    end

    hash
  end

end
