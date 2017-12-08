require 'xcodeproj'
require_relative '../02 - Ruby Helper/rubyscript_helper'

# Dir['x86_64/*'].each do |file|
#   filename = File.basename(file)
#   filename = file
#   if File.extname(filename) == '.d'
#     puts filename
#
#     parts = File.read(filename).split(' \\')
#     puts parts
#     break
#   end
# end

xcconfig_path = './0_sample'
#build_settings = Hash[*File.read(xcconfig_path).lines.map{|x| x.split(/\s*=\s*/, 2)}.flatten]


dump_object(Xcodeproj::Config::KEY_VALUE_PATTERN)
build_settings = Hash[*File.read(xcconfig_path).lines.map{|x| x.split(Xcodeproj::Config::KEY_VALUE_PATTERN, 2)}.flatten]

dump_object(build_settings)
# other_ldflags = build_settings['OTHER_LDFLAGS']
#
# other_ldflags = remove_ldflags_for_framework(name, other_ldflags, static_framework_pod_list + dynamic_framework_pod_list)
# other_ldflags = add_ldflags_for_framework(name, other_ldflags, static_framework_pod_list)

# build_settings['OTHER_LDFLAGS'] = other_ldflags

File.open(xcconfig_path, 'r') { |file|
  build_settings.to_h.each do |key,value|
    # file.puts "#{key} = #{value}"
    puts "#{key} = #{value}"
  end
}

