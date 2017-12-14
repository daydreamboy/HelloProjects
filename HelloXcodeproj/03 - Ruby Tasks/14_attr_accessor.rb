class Log
  # Error: can't support
  # attr_accessor @level

  def initialize
    self.location = 'Windows'
    self.level = 'DEBUG'
  end

  attr_accessor :level
  attr_accessor 'location'

  @classLevel

  def self.changeClassLevel(level)
    @classLevel = level
  end

  def self.printClassLevel
    puts @classLevel
  end

  def changeLevel(level)
    self.level = level
  end
end

# Log.level 'INFO'

logger = Log.new

puts logger.level
puts logger.location

puts '=============='

# logger.level = 'INFO'
logger.changeLevel('ERROR')
logger.location = 'Mac OS X'

puts logger.level
puts logger.location

puts '=============='

Log.changeClassLevel("SomeLevel")
Log.printClassLevel
