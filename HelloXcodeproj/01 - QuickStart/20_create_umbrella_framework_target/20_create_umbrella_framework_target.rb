require 'xcodeproj'
require 'fileutils'
require_relative '../../02 - Ruby Helper/rubyscript_helper'

src_folder_path = File.expand_path('template_files/20_umbrella_framework_origin.xcodeproj', '.')
dest_folder_path = File.expand_path('20_umbrella_framework.xcodeproj', '.')

# Configurations
target_name = 'umbrella_framework'
xcodeproj_path = dest_folder_path.clone

# make a copy of xcodeproj folder
FileUtils.mkdir_p dest_folder_path
FileUtils.cp_r(Dir.glob("#{src_folder_path}/*"), "#{dest_folder_path}")

# make a copy of Info.plist
src_file_path = File.expand_path('template_files/Info.plist', '.')
dest_folder_path = File.expand_path("Target Support Files/#{target_name}", '.')

FileUtils.mkdir_p dest_folder_path
FileUtils.cp("#{src_file_path}", "#{dest_folder_path}")

project = Xcodeproj::Project.open(xcodeproj_path)

# create a group (optional)
project.new_group(target_name, nil, :group)

# create a target
target = project.new_target(:framework, target_name, :ios, "11.0", nil, :objc)

# change build settings
target.build_configurations.each do |config|
  config.build_settings['DEFINES_MODULE'] = 'NO'
  config.build_settings['VERSIONING_SYSTEM'] = ''
  config.build_settings['INFOPLIST_FILE'] = "Target Support Files/#{target_name}/Info.plist"
end

project.save(xcodeproj_path)