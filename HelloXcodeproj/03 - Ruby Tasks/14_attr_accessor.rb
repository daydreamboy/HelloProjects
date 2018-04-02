class Log
  # Error: can't support
  # attr_accessor @level

  def initialize
    self.location = 'Windows'
    self.level = 'DEBUG'
    @privateIvar = 'privateIvar'
  end

  attr_accessor :level
  attr_accessor 'location'
  # @see https://stackoverflow.com/questions/5046831/why-use-rubys-attr-accessor-attr-reader-and-attr-writer
  attr_reader :readonlyString



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

  def readonlyString
    @readonlyString = 'readonly string'
  end

  # ----------------------------------- #
  private

  attr_accessor :privateIvar

end

# Log.level 'INFO'

logger = Log.new

# Note: crash here for undefined method `readonlyString='
# logger.readonlyString = 'some string'

puts logger.level
puts logger.location
puts logger.readonlyString
puts logger.privateIvar

puts '=============='

# logger.level = 'INFO'
logger.changeLevel('ERROR')
logger.location = 'Mac OS X'

puts logger.level
puts logger.location

puts '=============='

Log.changeClassLevel("SomeLevel")
Log.printClassLevel
