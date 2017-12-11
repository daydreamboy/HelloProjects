require 'xcodeproj'
require_relative '../02 - Ruby Helper/rubyscript_helper'

file = File.new('Sample/17_sample.xcconfig')
dump_object(file)
config = Xcodeproj::Config.new(file)
dump_object(config)

# dump_object(config.frameworks)
# dump_object(config.libraries)
# dump_object(config.weak_frameworks)
# dump_object(config.other_linker_flags)
# dump_object(config.attributes['FRAMEWORK_SEARCH_PATHS'])

parts = config.attributes['FRAMEWORK_SEARCH_PATHS'].split

# @see https://stackoverflow.com/questions/30276873/ruby-wrap-each-element-of-an-array-in-additional-quotes
parts = parts.map { |item|
  if item != '$(inherited)'
    item.gsub!(/\A"|"\z/,'')
    item.gsub!(/\A'|'\z/,'')
    '"' + item + '"'
  else
    item
  end
}

config.attributes['FRAMEWORK_SEARCH_PATHS'] = parts.sort!.join(' ')

config.libraries.delete('XXX')
config.frameworks.add('YYY')

config.save_as(Pathname.new("#{__FILE__}.xcconfig"))
