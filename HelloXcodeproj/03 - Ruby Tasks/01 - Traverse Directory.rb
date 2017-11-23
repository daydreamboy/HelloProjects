#encoding: utf-8

require_relative '../02 - Ruby Helper/rubyscript_helper'

dir_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCoreData/HelloCoreDataWithCocoaPods'

# @see https://stackoverflow.com/questions/2370702/one-liner-to-recursively-list-directories-in-ruby
Dir.glob(dir_path + '/**/*') do |item|
  next if item == '.' or item == '..'

  # @see https://stackoverflow.com/questions/10115591/check-if-a-filename-is-a-folder-or-a-file
  if !File.directory?(item) && File.exist?(item)
    # dump_object(item)

    text = File.read(item)
    new_contents = text.gsub(/wesleychen.cl@alibaba-inc.com/, 'wesley4chen@gmail.com')

    File.open(item, 'w') { |file| file.puts new_contents }
  end
end