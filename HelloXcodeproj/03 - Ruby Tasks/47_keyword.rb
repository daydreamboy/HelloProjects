require_relative '../02 - Ruby Helper/rubyscript_helper'

# @see https://stackoverflow.com/questions/16626980/how-is-the-line-and-file-constants-implemented-in-ruby

puts __LINE__
dump_object(__LINE__)
dump_object(__FILE__)