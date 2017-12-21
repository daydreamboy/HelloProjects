require_relative '../02 - Ruby Helper/rubyscript_helper'

# Case 1: Define method take callback as parameters

def target(name, options = nil)
  if options
    raise Informative, "Unsupported options `#{options}` for " "target `#{name}`."
  end

  dump_object(block_given?)

  yield if block_given?
end

def pod_im(name)
  puts name

  dump_object(block_given?)
end

target 'MyTarget' do
  pod_im 'AFN'
end

# Case 2: store callback as value in Hash

dict = {
    :callbackWithoutParam => lambda{ puts 'block1 called' },
    :callbackWithParams => lambda{ |x, y| puts "#{x} + #{y} = #{x + y}" },
    :callbackString => "lambda { |attributes|
                                  puts attributes
                                }"
}

dict[:callbackWithoutParam].call()
dict[:callbackWithParams].call(1, 2)

callback = eval(dict[:callbackString])
dump_object(callback)

if callback.is_a?(Proc)
  callback.call({ 'key' => 'value' })
end
