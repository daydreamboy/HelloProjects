# @see https://stackoverflow.com/questions/31859386/can-i-use-else-if-over-elsif

def do_something(param)
  if param.is_a?(String)
    puts "It's a string"
  elsif param.is_a?(Array)
    puts "It's an array"
  else if param.is_a?(Hash)
         puts "It's a dict"
       end
  end
end

do_something('Hello')
do_something(['1', '2'])
do_something({'1' => 'a', '2' => 'b'})
