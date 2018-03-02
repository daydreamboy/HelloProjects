#encoding: utf-8

require_relative '../02 - Ruby Helper/rubyscript_helper'

dir_path = '/Users/wesley_chen/Library/Developer/Xcode/DerivedData/FrameworkPackager-bummefsurbzviaadegxujobwktgw/Build/Intermediates.noindex/Pods.build/Debug-iphoneos/WXOpenIMSDK.build/Objects-normal/arm64'

# @see https://stackoverflow.com/questions/2370702/one-liner-to-recursively-list-directories-in-ruby
Dir.glob(dir_path + '/**/*') do |item|
  next if item == '.' or item == '..'

  if !File.directory?(item) && File.exist?(item) && File.extname(item) == '.o'
    # @see https://stackoverflow.com/a/3951391
    output = `nm -m "#{item}" | grep dlsym`
    result = $?.success?

    if (result)
      dump_object(result)
      dump_object(output)
    end
  end
end