require 'xcodeproj'

project_path = './Sample/Sample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
  puts target
  target.build_configurations.each do |config|
    # puts config
    puts config.name + ': '
    puts config.build_settings
    config.build_settings['OTHER_LDFLAGS'] = '-ObjC'
  end
  puts '------------'
end

project.save()