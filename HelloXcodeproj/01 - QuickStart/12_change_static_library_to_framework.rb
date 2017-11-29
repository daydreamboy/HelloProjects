require 'xcodeproj'
require 'pathname'
require_relative '../02 - Ruby Helper/rubyscript_helper'

project_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods/Pods.xcodeproj'
dest_target = 'AwesomeSDK'
root_dir = '/Users/wesley_chen/Ali-Projects/Integration_CocoaPods_New/wxopenimsdk'

rootDirPath = Pathname.new(root_dir)

# start code
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|

  if target.name == dest_target
    dump_object(target.product_type)
    target.product_type = 'com.apple.product-type.framework'

    dump_object(target.product_reference)
    fileReference = target.product_reference
    fileReference.name = "#{dest_target}.framework"
    fileReference.path = "#{dest_target}.framework"
    fileReference.explicit_file_type = 'wrapper.framework'
  end
end

project.save(project_path)
