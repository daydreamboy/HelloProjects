require_relative '../02 - Ruby Helper/rubyscript_helper'

module MethodSwizzle
  def self.method_before(clazz, method, &block)
    method_swizzle(clazz, method) do |binded, *args|
      block.call(*args)
      binded.call(*args)
    end
  end

  def self.method_after(clazz, method, &block)
    method_swizzle(clazz, method) do |binded, *args|
      binded.call(*args)
      block.call(*args)
    end
  end

  def self.method_swizzle(clazz, method, &block)
    begin
      origin_method = clazz.instance_method(method)
    rescue NameError => e
      puts "Not found method '#{method}' in '#{clazz}'"
      return
    end

    clazz.class_eval do
      define_method(method) do |*args|
        binded = origin_method.bind(self) # 这个self是当前block执行的时候bind的self，不是方法定义所在的self
        block.call(binded, *args)
      end
    end
  end
end


# MethodSwizzle::method_before(String, :to_s) do |*args|
#   # puts *args.inspect
#   # dump_object(*args)
#
#   param = *args
#
#   puts "before outputing #{param}"
# end
#
# puts 'abc'.to_s


class SomeClass
  def target(name, options = nil)
    if options
      raise Informative, "Unsupported options `#{options}` for " "target `#{name}`."
    end

    dump_object(block_given?)

    yield if block_given?
  end

  def pod_im(name)
    puts name
  end
end

MethodSwizzle::method_before(SomeClass, :target) do |*args|
  # puts *args.inspect
  # dump_object(*args)

  param = *args

  puts "before outputing #{param}"
end

clz = SomeClass.new
clz.target 'MyTarget' do
  clz.pod_im 'AFN'
end