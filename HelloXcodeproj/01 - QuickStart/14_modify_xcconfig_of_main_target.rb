require 'xcodeproj'
require 'pathname'
require_relative '../02 - Ruby Helper/rubyscript_helper'

project_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/AwesomeSDK.xcodeproj'
main_target_name = 'AwesomeSDK_Example'
ldflags_opt_to_remove = '-l"AwesomeSDK"'

# start code
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|

  if target.name == main_target_name
    target.build_configurations.each do |config|
      # @see cocoapods-post-install.rb in TBWangXin
      xcconfig_path = config.base_configuration_reference.real_path
      puts xcconfig_path
      build_settings = Hash[*File.read(xcconfig_path).lines.map{|x| x.split(/\s*=\s*/, 2)}.flatten]
      if build_settings['OTHER_LDFLAGS']
        other_ldflags = build_settings['OTHER_LDFLAGS']

        # remove the unwanted -l"xxx"
        if other_ldflags.include? ldflags_opt_to_remove
          index = other_ldflags.index(ldflags_opt_to_remove)
          length = ldflags_opt_to_remove.length
          first_path = other_ldflags[0, index]
          last_path = other_ldflags[index + length .. -1]
          exclude_ldflags = first_path + last_path
          # collapse whitespace
          exclude_ldflags = exclude_ldflags.split.join(' ')
          build_settings['OTHER_LDFLAGS'] = exclude_ldflags

          dump_object(exclude_ldflags)
        end

        # write build_settings dictionary to xcconfig
        File.open(xcconfig_path, 'w')
        build_settings.each do |key,value|
          File.open(xcconfig_path, 'a') {|file| file.puts "#{key} = #{value}"}
        end

      end
    end
  end
end

