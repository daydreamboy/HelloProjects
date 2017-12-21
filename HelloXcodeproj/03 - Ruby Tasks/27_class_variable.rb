class Utility
  @name

  def self.name
    @name
  end

  def self.name=(name)
    @name = name
  end

  def self.print_name
    puts Utility.name
  end

end

Utility.name = 'File Manager'
puts Utility.name
Utility.print_name
