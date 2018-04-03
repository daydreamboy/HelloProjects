require 'xcodeproj'
require 'fileutils'
require_relative '../../02 - Ruby Helper/rubyscript_helper'

src_folder_path = File.expand_path('.', '20_umbrella_framework_origin.xcodeproj')
dest_folder_path = File.expand_path('.', '20_umbrella_framework.xcodeproj')

# make a copy of xcodeproj folder
FileUtils.mkdir_p dest_folder_path
FileUtils.cp_r(Dir.glob("#{src_folder_path}/*"), "#{dest_folder_path}")

# Configurations
xcodeproj_path = dest_folder_path
target_name = 'umbrella_framework'

project = Xcodeproj::Project.open(xcodeproj_path)

# create a group
project.new_group(target_name, nil, :group)

# create a target
target = project.new_target(:framework, target_name, :ios, "11.0", nil,:objc)

# change build settings
target.build_configurations.each do |config|
  config.build_settings['DEFINES_MODULE'] = 'NO'
  config.build_settings['VERSIONING_SYSTEM'] = ''
end

project.save(xcodeproj_path)