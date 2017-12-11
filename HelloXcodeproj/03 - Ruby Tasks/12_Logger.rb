require 'colored2'
require 'logger'
require_relative '../02 - Ruby Helper/rubyscript_helper'

LOG_PREFIX = '[pod_tweaker]'

=begin
black:     30,
    red:       31,
    green:     32,
    yellow:    33,
    blue:      34,
    magenta:   35,
    cyan:      36,
    white:     37
}

EFFECTS = {
    no_color:   0,
    bold:       1,
    dark:       2,
    italic:     3,
    underlined: 4,
    reversed:   7,
    plain:      21, # non-bold
    normal:     22
=end

class Log

  # @see https://stackoverflow.com/questions/752717/how-do-i-use-define-method-to-create-class-methods
  define_singleton_method :level do |level|
    @@level = level
  end

  @@level = Logger::INFO
  @@logger = Logger.new(STDOUT)
  @@logger.level = @@level

  # level value
  # DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN (=SUCCESS)

  def self.i(msg)
    # @@logger.info(msg)
    if @@level <= Logger::INFO
      puts LOG_PREFIX + ' ' + msg
    end
  end

  def self.d(msg)
    # @@logger.debug(msg)
    if @@level <= Logger::DEBUG
      puts (LOG_PREFIX + ' ' + msg).cyan
    end
  end

  def self.w(msg)
    # @@logger.warn(msg)
    if @@level <= Logger::WARN
      puts (LOG_PREFIX + ' ' + msg).yellow
    end
  end

  def self.e(msg)
    # @@logger.error(msg)
    if @@level <= Logger::ERROR
      puts (LOG_PREFIX + ' ' + msg).red
    end
  end

  def self.s(msg)
    # @@logger.success(msg)
    if @@level <= Logger::UNKNOWN
      puts (LOG_PREFIX + ' ' + msg).green
    end
  end

end

dump_object(Logger::DEBUG)
dump_object(Logger::INFO)
dump_object(Logger::WARN)
dump_object(Logger::ERROR)
dump_object(Logger::FATAL)
dump_object(Logger::UNKNOWN)


Log.level Logger::DEBUG
# Log.level Logger::INFO
# Log.level Logger::WARN


Log.s 'success'
Log.e 'error'
Log.i 'info'
Log.w 'warn'
Log.d 'debug'