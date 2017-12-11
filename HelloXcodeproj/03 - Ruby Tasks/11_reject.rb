arr = ['1', '2', '3', '4', '5']
list_to_remove = ['5', '4']

arr.reject! do |item|
  list_to_remove.include? item
end

puts arr

res = (arr + list_to_remove).map { |item| 'number: ' + item }
puts res
