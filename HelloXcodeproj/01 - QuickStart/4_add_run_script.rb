require 'xcodeproj'

project_path = './Sample/Sample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Configurations
run_script_name = '[IM] Copy To Pods'

project.targets.each do |target|
  if target.name == 'App'
    puts target.name

    copy_to_pods_phase_exists = false
    target.shell_script_build_phases.each do |phase|
      puts '[DEBUG] current run script: ' + phase.name
      if phase.name == run_script_name
        copy_to_pods_phase_exists = true
        break
      end
    end

    if copy_to_pods_phase_exists
      puts '[Error] Run Script: [IM] Copy To Pods exists. Abort.'
    else
      puts '[INFO] Adding Run Script: ' + run_script_name

      # https://stackoverflow.com/questions/20072937/add-run-script-build-phase-to-xcode-project-from-podspec
      new_phase = target.new_shell_script_build_phase(run_script_name)
      new_phase.shell_script = 'echo "hello, world"'
    end
  end
end

project.save()
