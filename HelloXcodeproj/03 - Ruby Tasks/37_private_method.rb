class Log

  def initialize
    self.location = 'Windows'
    self.level = 'DEBUG'
    @privateIvar = 'private ivar string'
    @readonlyString = 'readonlyString'
  end

  attr_accessor :level
  attr_accessor 'location'
  # @see https://stackoverflow.com/questions/5046831/why-use-rubys-attr-accessor-attr-reader-and-attr-writer
  attr_reader :readonlyString

  # ----------------------------------- #
  private

  attr_accessor :privateIvar

end

logger = Log.new

logger.readonlyString
# Crash: private method `privateIvar' called for #<Log:0x007f926920c990> (NoMethodError)
# logger.privateIvar

# Solution 1: using instance_eval
# @see https://stackoverflow.com/questions/4293215/understanding-private-methods-in-ruby
begin
  logger.privateIvar
rescue Exception=>e
  puts "That didn't work: #{e}"
end

returnVal = logger.instance_eval{ privateIvar }
puts returnVal

# Solution 2: using category method
class Log
  def exposure_privateIvar
    # Note: not self.privateIvar
    privateIvar
  end
end

puts logger.exposure_privateIvar


