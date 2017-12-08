require 'xcodeproj'
require_relative '../02 - Ruby Helper/rubyscript_helper'

file = File.new('Sample/17_sample.xcconfig')
dump_object(file)
config = Xcodeproj::Config.new(file)
dump_object(config)

dump_object(config.frameworks)
dump_object(config.libraries)
dump_object(config.weak_frameworks)
dump_object(config.other_linker_flags)

config.libraries.delete('XXX')
config.frameworks.add('YYY')

config.save_as(Pathname.new("#{__FILE__}.xcconfig"))
