require_relative '../../02 - Ruby Helper/rubyscript_helper'
require 'pathname'

headers_folder_path = '/Users/wesley_chen/Downloads/WXOpenIMExtensionIntegration.framework/WXOpenIMTribeCore.framework/Versions/A/Headers'
search_folder_path = '/Users/wesley_chen/Ali-Projects/i_tb_cocoapods/wxopenimsdk/'
root_dir = '/Users/wesley_chen/Ali-Projects/i_tb_cocoapods/wxopenimsdk'

rootDirPath = Pathname.new(root_dir)

public_header_file_names = Dir["#{headers_folder_path}/*"].sort.map do |file_path|
  File.basename(file_path)
end

public_header_file_paths = Dir.glob(search_folder_path + '/**/*').reject do |item|
  item == '.' or item == '..'
end.select do |item|
  !File.directory?(item) && File.exist?(item)
end.select do |item|
  public_header_file_names.include?(File.basename(item))
end.map do |item|
  pathname = Pathname.new(item).relative_path_from(rootDirPath)
  pathname.to_s
end.uniq.sort

public_header_file_paths.each do |item|
  puts "\"#{item}\","
end
