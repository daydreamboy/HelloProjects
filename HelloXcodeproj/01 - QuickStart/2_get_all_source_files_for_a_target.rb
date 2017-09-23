require 'xcodeproj'

project_path = './Sample/Sample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
puts target

files = target.source_build_phase.files.to_a.map do |pbx_build_file|
  pbx_build_file.file_ref.real_path.to_s

end.select do |path|
  path.end_with?(".m", ".mm", ".swift")
end.select do |path|
  File.exists?(path)
end

puts files
