#encoding: utf-8

require_relative '../02 - Ruby Helper/rubyscript_helper'

class Subclass
  def self.classMethod
  end

  def instanceMethod
  end

  def one;    end
  def two(a); end
  def three(*a);  end
  def four(a, b); end
  def five(a, b, *c);    end
  def six(a, b, *c, &d); end
  def seven(a, b, x:0); end
  def eight(x:, y:); end
  def nine(x:, y:, **z); end
  def ten(*a, x:, y:); end
end

## Test Methods

def check_method_source_location
  dump_object(Subclass.method(:classMethod).source_location)
  dump_object(Subclass.new.method(:instanceMethod).source_location)
end

def check_method_number_of_arguments
  dump_object(Subclass.method('classMethod').arity)
  dump_object(Subclass.new.method('instanceMethod').arity)

  dump_object(Subclass.new.method(:one).arity)
end


check_method_source_location
check_method_number_of_arguments