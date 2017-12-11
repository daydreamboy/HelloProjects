class Log
  # Error: can't support
  # attr_accessor @level

  def initialize
    self.location = 'Windows'
    self.level = 'DEBUG'
  end

  attr_accessor :level
  attr_accessor 'location'
end

# Log.level 'INFO'

logger = Log.new

puts logger.level
puts logger.location

puts '=============='

logger.level = 'INFO'
logger.location = 'Mac OS X'

puts logger.level
puts logger.location
