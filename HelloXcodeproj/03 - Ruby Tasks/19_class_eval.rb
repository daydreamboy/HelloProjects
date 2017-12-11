
class Person

end

a = %q{def hello() puts "Hello there!" end}
Person.class_eval(a)

p = Person.new
p.hello

Person.class_eval do
  puts 'do something'
end
