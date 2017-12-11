require_relative '../02 - Ruby Helper/rubyscript_helper'

def foo
  puts 'foo'
end

def baz
  puts 'baz'
end

class Person

end

Person.class_eval do
  def foo
    puts 'foo'
  end

  def baz
    puts 'baz'
  end

  alias_method :baz, :foo
end

baz

p = Person.new
p.baz

