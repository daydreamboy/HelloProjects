require 'logger'
require 'colored2'

def dump_object(arg)
  loc = caller_locations.first
  line = File.read(loc.path).lines[loc.lineno - 1]

  # get string started by `dump_object`
  callerString = line[/#{__method__}\(.*?\)/].to_s

  # get parameter name of `dump_object`
  argName = callerString[/\(.*?\)/]
  # get content of parenthesis
  argNameStr = argName.gsub!(/^\(|\)?$/, '')

  filename = loc.path
  lineNo = loc.lineno

  Log.d "[Debug] #{filename}:#{lineNo}: #{argNameStr} = (#{arg.class}) #{arg.inspect}"
end

class Log
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::DEBUG

  def self.i(msg)
    # @@logger.info(msg)
    puts '[IM] ' + msg
  end

  def self.d(msg)
    # @@logger.debug(msg)
    puts ('[IM] ' + msg).blue
  end

  def self.w(msg)
    # @@logger.warn(msg)
    puts ('[IM] ' + msg).yellow
  end

  def self.e(msg)
    # @@logger.error(msg)
    puts ('[IM] ' + msg).red
  end

  def self.s(msg)
    # @@logger.error(msg)
    puts ('[IM] ' + msg).green
  end
end