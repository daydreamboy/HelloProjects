require 'xcodeproj'

project_path = './Sample/Sample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
  puts target
  target.build_configurations.each do |config|
    puts config
    config.build_settings['OTHER_LINKER_FLAG'] ||= 'TRUE'
  end
  puts '------------'
end