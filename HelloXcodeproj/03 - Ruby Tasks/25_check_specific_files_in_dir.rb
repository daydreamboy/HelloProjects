require_relative '../02 - Ruby Helper/rubyscript_helper'

def check_valid_for_support_files?(support_file_src_folder)
  valid = true

  if !Dir.exists?(support_file_src_folder) || Dir.empty?(support_file_src_folder)
    Log.e "#{support_file_src_folder} not exists or is empty!"
    valid = false
  else
    if Dir["#{support_file_src_folder}/Info.plist"].empty?
      Log.e "#{support_file_src_folder} does not have a Info.plist!"
      valid = false
    end

    if Dir["#{support_file_src_folder}/*.xcconfig"].empty?
      Log.e "#{support_file_src_folder} does not have a .xconfig file!"
      valid = false
    end

    if Dir["#{support_file_src_folder}/*.modulemap"].empty?
      Log.e "#{support_file_src_folder} does not have a .modulemap file!"
      valid = false
    end

    if Dir["#{support_file_src_folder}/*-umbrella.h"].empty?
      Log.e "#{support_file_src_folder} does not have a xxx-umbrella.h file!"
      valid = false
    end
  end
  valid
end

if check_valid_for_support_files?('./25_support_file_src_folder')
  Log.i 'valid!'
else

end