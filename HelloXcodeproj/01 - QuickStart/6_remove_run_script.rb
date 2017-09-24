require 'xcodeproj'

project_path = './Sample/Sample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Configurations
run_script_name = '[IM] Copy To Pods'

project.targets.each do |target|
  if target.name == 'App'
    puts target.name

    copy_to_pods_phase = nil
    target.shell_script_build_phases.each do |phase|
      puts '[DEBUG] current run script: ' + phase.name
      if phase.name == run_script_name
        copy_to_pods_phase = phase
        break
      end
    end

    if copy_to_pods_phase
      puts '[Debug] Removing Run Script: ' + copy_to_pods_phase.name
      # https://github.com/CocoaPods/Xcodeproj/issues/154
      copy_to_pods_phase.remove_from_project
    else
      puts '[Debug] not found Run Script: ' + run_script_name
    end

    target.shell_script_build_phases.each do |phase|
      puts '[DEBUG] current run script: ' + phase.name
    end
  end
end

project.save(project.path)
