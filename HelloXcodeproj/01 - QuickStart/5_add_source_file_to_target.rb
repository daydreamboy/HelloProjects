require 'xcodeproj'

project_path = './Sample/Sample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Configurations
# Note: file path must be relative to .xcodeproj
header_file_to_add_paths = ['./SourceFileToAdd/AutomaticCreated.h']
source_file_to_add_paths = ['./SourceFileToAdd/AutomaticCreated.m']

#added group name
added_group_name = 'SourceFileToAdd'

# 1. find the target
app_target = nil
project.targets.each do |target|
  if target.name == 'App'
    app_target = target
    puts '[Debug] found App target'
  end
end

puts '[Debug] current source file: '
app_target.source_build_phase.files.each do |file|
  puts file.display_name
end

# 2. Add new group  to main group
sourceFileToAdd_group = project.main_group[added_group_name]
unless sourceFileToAdd_group
  puts '[Debug] Creating Group: SourceFileToAdd'
  sourceFileToAdd_group = project.main_group.new_group(added_group_name)
end

# 3. Add header files to new group
header_file_to_add_paths.each do |path|

  # make correct path for files
  file_path = File.join(File.dirname(project_path), path)
  file_pathname = Pathname.new(File.expand_path(file_path))

  # https://github.com/CocoaPods/cocoapods-acknowledgements/blob/master/lib/cocoapods_acknowledgements.rb#L8-L26
  file_ref = sourceFileToAdd_group.files.find { |file|
    file.real_path == file_pathname
  }

  unless file_ref
    puts '[Debug] Adding ' + path + ' to Group ' + '`SourceFileToAdd`'
    sourceFileToAdd_group.new_file(path)
  end

end

# 4. Add source file to new group and target
source_file_to_add_paths.each do |path|

  # make correct path for files
  file_path = File.join(File.dirname(project_path), path)
  file_pathname = Pathname.new(File.expand_path(file_path))

  # https://github.com/CocoaPods/cocoapods-acknowledgements/blob/master/lib/cocoapods_acknowledgements.rb#L8-L26
  file_ref = sourceFileToAdd_group.files.find { |file|
    file.real_path == file_pathname
  }

  unless file_ref
    puts '[Debug] Adding ' + path + ' to Group ' + '`SourceFileToAdd`'
    file_ref = sourceFileToAdd_group.new_file(path)
  end

  included = app_target.source_build_phase.files.find { |file| file.file_ref.real_path == file_ref.real_path }
  unless included
    puts '[Debug] Adding ' + file_ref.name + ' to App target'
    app_target.add_file_references([file_ref])
  end

end

# 5. Save .pbxproj
project.save(project.path)
