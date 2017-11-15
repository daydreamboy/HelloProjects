require 'xcodeproj'
require_relative '../02 - Ruby Helper/rubyscript_helper'

project_path = './Sample/Sample.xcodeproj'
dest_target = 'App'

# start code
files = []
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|
  # dump_object(target)

  if target.name == dest_target
    files = target.source_build_phase.files.to_a.map do |pbx_build_file|
      pbx_build_file.file_ref.real_path.to_s

    end.select do |path|
      path.end_with?(".m", ".mm", ".swift", ".c", ".cpp")
    end.select do |path|
      File.exists?(path)
    end
  end
end

puts files
