require_relative './rubyscript_helper'

string = 'hello, world'
dict = {"key" => "value"}
array = []
number = 3

dump_object(string)
dump_object(dict)
dump_object(array)
dump_object(number)

dump_object("string")
dump_object({"key" => "value"})
dump_object([1, 2, 3])
dump_object(3.14)

