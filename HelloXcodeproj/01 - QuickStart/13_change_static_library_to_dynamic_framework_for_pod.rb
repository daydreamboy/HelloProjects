require 'xcodeproj'
require 'fileutils'
require 'pathname'
require_relative '../02 - Ruby Helper/rubyscript_helper'

# project_path = './Sample/Sample.xcodeproj'
project_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods/Pods.xcodeproj'
dest_target_name = 'AwesomeSDK_dynamic_framework'

support_file_source_folder = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/AwesomeSDK_dynamic_framework/Target Framework Files'
support_file_dest_folder = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods'
pod_name = 'AwesomeSDK_dynamic_framework'
xcconfig_name = 'AwesomeSDK_dynamic_framework.xcconfig'

new_group_name = File.basename(support_file_source_folder)
support_file_folder_path = File.join(support_file_dest_folder, new_group_name)


# Function 1:
def change_static_library_to_framework(project, dest_target_name)
  project.targets.each do |target|

    if target.name == dest_target_name
      #
      # 'com.apple.product-type.library.static'
      target.product_type = 'com.apple.product-type.framework'

      fileReference = target.product_reference
      fileReference.name = "#{dest_target_name}.framework"
      fileReference.path = "#{dest_target_name}.framework"
      fileReference.explicit_file_type = 'wrapper.framework'

      break
    end
  end
end


# 1. Copy supported files
FileUtils.cp_r support_file_source_folder, support_file_dest_folder

# var holders
dest_target = nil
xcconfig_fileReference = nil

project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|
  if target.name == dest_target_name
    dest_target = target
    break
  end
end

# 2. Find pod name group in 'Development Pods' group
main_group = project.main_group
puts 'groups in Main Group: '
dump_object(main_group.children)

main_group.children.each do |group|

  if group.name == 'Development Pods'
    group.children.each do |sub_group|

      if sub_group.name == pod_name
        puts 'Add new group: ' + new_group_name
        new_group = sub_group.new_group(new_group_name)
        Dir.glob(support_file_folder_path + '/**/*') do |item|
          next if item == '.' or item == '..'

          # 3. Add supported files to new group
          if !File.directory?(item) && File.exist?(item)
            fileReference = new_group.new_file(item)

            # 4. Check xcconfig file
            if File.basename(item) == xcconfig_name
              puts 'found item：' + item
              xcconfig_fileReference = fileReference
            end

          end
        end
      end

    end
  end
end

# 4. Change build configuratio of the target

if dest_target && xcconfig_fileReference
  dump_object(dest_target)
  dump_object(xcconfig_fileReference)
  dest_target.build_configurations.each do |config|
    config.base_configuration_reference = xcconfig_fileReference
    config.build_settings['PRIVATE_HEADERS_FOLDER_PATH'] = '$(CONTENTS_FOLDER_PATH)/PrivateHeaders'
    config.build_settings['PUBLIC_HEADERS_FOLDER_PATH'] = '$(CONTENTS_FOLDER_PATH)/Headers'
    config.build_settings['OTHER_LDFLAGS'] = '-ObjC -undefined dynamic_lookup'
  end
end

change_static_library_to_framework(project, dest_target_name)

project.save(project_path)