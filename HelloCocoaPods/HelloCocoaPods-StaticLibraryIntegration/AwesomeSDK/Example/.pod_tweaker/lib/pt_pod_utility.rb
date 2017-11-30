require_relative '../lib/pt_utility'
require_relative '../lib/pt_config'
require 'xcodeproj'
require 'fileutils'

project_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods/Pods.xcodeproj'
dest_target_name = 'AwesomeSDK_dynamic_framework'

support_file_source_folder = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/AwesomeSDK_dynamic_framework/Target Framework Files'
support_file_dest_folder = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods'
pod_name = 'AwesomeSDK_dynamic_framework'
xcconfig_name = 'AwesomeSDK_dynamic_framework.xcconfig'

new_group_name = File.basename(support_file_source_folder)
support_file_folder_path = File.join(support_file_dest_folder, new_group_name)

# main callee methods
def convert_development_pod_from_library_to_framework(project, pod_name, support_file_src_folder, support_file_dest_folder, xcconfig_name, isDynamic)

  new_group_name = isDynamic ? "#{pod_name}-DF Support Files" : "#{pod_name}-SF Support Files"

  # 1. Prepare target support files
  xcconfig_fileRef = add_target_support_files_to_development_pod(project, pod_name, new_group_name, support_file_src_folder, support_file_dest_folder, xcconfig_name)

  # 2. Change static library to dynamic framework
  target = change_library_to_framework(project, pod_name)

  # 3. Add some build settings
  change_build_settings_for_target(target, xcconfig_fileRef, isDynamic)
end

def change_build_settings_for_target(target, xcconfig_fileRef, isDynamic)
  # Change build configuratio of the target

  if target && xcconfig_fileRef
    target.build_configurations.each do |config|

      config.base_configuration_reference = xcconfig_fileRef
      config.build_settings['PRIVATE_HEADERS_FOLDER_PATH'] = '$(CONTENTS_FOLDER_PATH)/PrivateHeaders'
      config.build_settings['PUBLIC_HEADERS_FOLDER_PATH'] = '$(CONTENTS_FOLDER_PATH)/Headers'
      config.build_settings['OTHER_LDFLAGS'] = isDynamic ? '-ObjC -undefined dynamic_lookup' : '-ObjC'
      config.build_settings['INFOPLIST_FILE'] = "#{POD_TARGET_SUPPORT_DEST_FOLDER_NAME}/#{target}/Info.plist"
      config.build_settings['MODULEMAP_FILE'] = "#{POD_TARGET_SUPPORT_DEST_FOLDER_NAME}/#{target}/#{target}.modulemap"
      config.build_settings['MACH_O_TYPE'] = isDynamic ? 'mh_dylib' : 'staticlib'
      config.build_settings['DEFINES_MODULE'] = 'YES'
      config.build_settings['WRAPPER_EXTENSION'] = 'framework'
      config.build_settings['VERSIONING_SYSTEM'] = 'apple-generic'
      config.build_settings['EXECUTABLE_EXTENSION'] = ''
      config.build_settings['EXECUTABLE_PREFIX'] = ''
      config.build_settings['CURRENT_PROJECT_VERSION'] = '1'
      config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = '1'
      config.build_settings['DYLIB_CURRENT_VERSION'] = '1'
      config.build_settings['DYLIB_INSTALL_NAME_BASE'] = '@rpath'
      config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @loaderp_path/Frameworks'
      config.build_settings['INSTALL_PATH'] = '$(LOCAL_LIBRARY_DIR)/Frameworks'
      if isDynamic
        # Note: ENABLE_BITCODE = YES conflict with -undefined
        # ld: -undefined and -bitcode_bundle (Xcode setting ENABLE_BITCODE=YES) cannot be used together
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end
end

def add_target_support_files_to_development_pod(project, pod_name, new_group_name, support_file_src_folder, support_file_dest_folder, xcconfig_name)

  # copy supported files
  FileUtils.mkdir_p support_file_dest_folder
  FileUtils.cp_r support_file_src_folder, support_file_dest_folder

  dest_group = nil
  xcconfig_fileRef = nil

  # find pod name group in 'Development Pods' group
  main_group = project.main_group
  main_group.children.each do |group|

    if group.name == 'Development Pods'
      group.children.each do |sub_group|
        if sub_group.name == pod_name
          dest_group = sub_group
          break
        end
      end
    end
  end

  if dest_group
    new_group = dest_group.new_group(new_group_name)
    Dir.glob(support_file_dest_folder + '/**/*') do |item|
      next if item == '.' or item == '..'

      # add supported files to new group
      if !File.directory?(item) && File.exist?(item)
        fileReference = new_group.new_file(item)

        # check xcconfig file
        if File.basename(item) == xcconfig_name
          xcconfig_fileRef = fileReference
        end

      end
    end
  end

  return xcconfig_fileRef
end

def change_library_to_framework(project, target_name)

  target = find_target_for_name(project, target_name)
  #
  # 'com.apple.product-type.library.static'
  target.product_type = 'com.apple.product-type.framework'

  fileReference = target.product_reference
  fileReference.name = "#{target_name}.framework"
  fileReference.path = "#{target_name}.framework"
  fileReference.explicit_file_type = 'wrapper.framework'
  return target
end

# Helpers

def find_target_for_name(project, target_name)
  dest_target = nil
  project.targets.each do |target|
    if target.name == target_name
      dest_target = target
      break
    end
  end
  return dest_target
end
