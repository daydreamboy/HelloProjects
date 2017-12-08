require_relative '../02 - Ruby Helper/rubyscript_helper'
require 'cocoapods'

$index = 0
def do_something(name, param)
  # @see https://stackoverflow.com/questions/3717519/no-increment-operator-in-ruby
  #$index++
  $index += 1

  dict = param
  dump_object(dict[:param1])
  dump_object(dict[:param2])
  param1 = dict[:param1]
  # @see https://stackoverflow.com/questions/15769739/determining-type-of-an-object-in-ruby
  if param1.is_a?(String)
    puts "#{$index}. It's a string"
  else param1.is_a?(Array)
    puts "#{$index}. It's an array"
  end
end

do_something 'some',
             :param1 => ['a', 'b'],
             :param2 => 'string'
do_something 'some',
             :param1 => 'a string',
             :param2 => 'string'
