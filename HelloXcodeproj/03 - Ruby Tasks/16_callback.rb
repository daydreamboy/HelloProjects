require_relative '../02 - Ruby Helper/rubyscript_helper'

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

