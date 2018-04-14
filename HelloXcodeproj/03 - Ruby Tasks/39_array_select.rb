require_relative '../02 - Ruby Helper/rubyscript_helper'


arr = %w(1 2 3)

ret = arr.select { |item| item == '4' }

dump_object(ret)

if ret.empty?
  puts "not found"
else
  puts ret
end


