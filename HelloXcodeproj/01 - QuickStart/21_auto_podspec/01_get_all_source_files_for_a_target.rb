require 'xcodeproj'
require 'pathname'
require_relative '../../02 - Ruby Helper/rubyscript_helper'

project_path = '/Users/wesley_chen/Ali-Projects/i_tb_cocoapods/wxopenimsdk/WXSDK/project/INet/INet.xcodeproj'

dest_target = 'INet_Contact'
root_dir = '/Users/wesley_chen/Ali-Projects/i_tb_cocoapods/wxopenimsdk'

rootDirPath = Pathname.new(root_dir)

# start code
project = Xcodeproj::Project.open(project_path)
project.targets.each do |target|

  if target.name == dest_target
    # @see https://stackoverflow.com/questions/5878697/how-do-i-remove-blank-elements-from-an-array
    files = target.source_build_phase.files.reject { |c| c.file_ref.nil? }

    filePaths = files.to_a.map do |file|
      file.file_ref.real_path.to_s
    end.select do |path|
      path.end_with?(".m", ".mm", ".swift", ".c", ".cpp")
    end.select do |path|
      File.exists?(path)
    end.map do |path|
      # @see https://stackoverflow.com/questions/11471261/ruby-how-to-calculate-a-path-relative-to-another-one
      Pathname.new(path).relative_path_from(rootDirPath)
    end.map do |pathName|
      path = pathName.to_s()
      path.sub(File.extname(path), '.{h,m,mm,c,cpp}')
    end.sort.each do |path|
      puts "\"#{path}\","
    end

    # puts filePaths
  end
end
