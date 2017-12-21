require 'xcodeproj'
require 'pathname'
require_relative '../02 - Ruby Helper/rubyscript_helper'

project_path = '/Users/wesley_chen/Ali-Projects/Integration_CocoaPods/WXOpenIMSDK_FrameworkPackager/wxopenimsdk/WXOpenIMUIKit/WXOpenIMUIKit.xcodeproj'

dest_target = 'WXOpenIMUIKitResource'
root_dir = '/Users/wesley_chen/Ali-Projects/Integration_CocoaPods/WXOpenIMSDK_FrameworkPackager/wxopenimsdk'

rootDirPath = Pathname.new(root_dir)

# start code
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|
  if target.name == dest_target
    # dump_object(target.resources_build_phase.files_references)
    # dump_object(target.resources_build_phase.files)
    #
    target.resources_build_phase.files_references.to_a.map do |file_ref|
      file_ref.real_path.to_s
    end.select do |item|
      File.exist?(item) && !File.directory?(item)
    end.map do |item|
      pathname = Pathname.new(item).relative_path_from(rootDirPath)
      pathname.to_s
    end.sort.each do |item|
      puts "\"#{item}\","
    end
  end
end