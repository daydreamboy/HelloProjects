lib_path = File.expand_path('.pod_tweaker/lib', File.dirname(__FILE__))
# prepend lib path to $LOAD_PATH
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

# not need to require '.pod_tweaker/lib/pt_utility' for its folder has been added to $LOAD_PATH
require 'pt_utility'
require 'pt_pod_utility'
require 'pt_xcconfig_utility'
require 'pt_config'
require 'pt_install_dynamic_framework'
require 'xcodeproj'

# @see https://stackoverflow.com/questions/12112765/how-to-reference-global-variables-and-class-variables
$pod_dict = { }

def pod_im(name, *param)

  # @see https://stackoverflow.com/questions/1465569/ruby-how-can-i-copy-a-variable-without-pointing-to-the-same-object
  $pod_dict[name] = param.last.clone

  remove_key(*param, :use_framework)
  remove_key(*param, :is_dynamic)

  pod name, *param
end

def remove_key(*param, key)
  hash = param.last
  if hash.is_a?(Hash) && hash.has_key?(key)
    hash.delete(key)
  end
end

Pod::HooksManager.register('cocoapods-stats', :post_install) do |installer_context|

  static_framework_pod_list = []
  dynamic_framework_pod_list = []

  pods_dir = File.expand_path('Pods', File.dirname(__FILE__))
  pods_xcodeproj_path = File.expand_path('Pods/Pods.xcodeproj', File.dirname(__FILE__))
  project = Xcodeproj::Project.open(pods_xcodeproj_path)

  $pod_dict.each do |pod_name, attrs|
    if attrs[:use_framework] == true

      # @see https://stackoverflow.com/questions/11436680/copy-contents-of-one-directory-to-another
      support_file_src_folder = File.expand_path("../#{pod_name}/#{POD_TARGET_SUPPORT_SRC_FOLDER_NAME}", File.dirname(__FILE__)) + '/.'
      support_file_dest_folder = File.expand_path("./Pods/#{POD_TARGET_SUPPORT_DEST_FOLDER_NAME}/#{pod_name}", File.dirname(__FILE__))

      # dump_object(support_file_src_folder)
      # dump_object(support_file_dest_folder)

      if attrs[:is_dynamic] == false
        Log.s("Convert #{pod_name} to static framework")

        static_framework_pod_list.push(pod_name)

        isDynamic = false
        xcconfig_name = "#{pod_name}-SF.xcconfig"

        convert_development_pod_from_library_to_framework(project, pod_name, support_file_src_folder, support_file_dest_folder, xcconfig_name, isDynamic)
      else
        Log.s("Convert #{pod_name} to dynamic framework")

        dynamic_framework_pod_list.push(pod_name)

        isDynamic = true
        xcconfig_name = "#{pod_name}-DF.xcconfig"

        convert_development_pod_from_library_to_framework(project, pod_name, support_file_src_folder, support_file_dest_folder, xcconfig_name, isDynamic)
      end
    end
  end

  project.save(pods_xcodeproj_path)

  first_target_of_user_project = nil
  installer_context.umbrella_targets.each do |target|
    if !target.specs.empty?
      target.user_targets.each do |user_target|
        first_target_of_user_project = user_target
        break
      end
    end
  end

  if first_target_of_user_project
    change_xcconfig_of_main_target(first_target_of_user_project, dynamic_framework_pod_list, static_framework_pod_list)
  else
    Log.e "Can't find a target in App"
  end

  add_codesnippet_for_install_dynamic_framework(pods_dir, first_target_of_user_project.name, dynamic_framework_pod_list)

end