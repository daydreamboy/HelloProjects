
require_relative '../../02 - Ruby Helper/rubyscript_helper'
require 'fileutils'

src_file_name = 'script.sh'
src_file_path = File.expand_path(src_file_name, '.')

dest_file_name = src_file_name
dest_file_path = File.expand_path("folder/#{dest_file_name}", '.')

dump_object(src_file_path)
dump_object(dest_file_path)

if File.exist?(dest_file_path)
  puts 'File exists'
else
  dirname = File.dirname(dest_file_path)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end

  FileUtils.cp src_file_path, dest_file_path
  FileUtils.chmod 0755, dest_file_path
end
