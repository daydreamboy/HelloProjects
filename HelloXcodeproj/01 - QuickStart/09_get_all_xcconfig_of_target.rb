require 'xcodeproj'
require_relative '../02 - Ruby Helper/rubyscript_helper'

# project_path = './Sample/Sample.xcodeproj'
project_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods/Pods.xcodeproj'
dest_target = 'AwesomeSDK'

project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|
  if target.name == dest_target
    target.build_configurations.each do |config|
      fileReference = config.base_configuration_reference
      puts config.name + ': ' + fileReference.path
    end
  end
end


