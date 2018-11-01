#encoding: utf-8

require 'optparse'
require 'colored2'

class FrameworkUtility

  attr_accessor :cmd_parser
  attr_accessor :cmd_options

  # initialize for new
  def initialize
    self.cmd_options = {}

    self.cmd_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} PATH/TO/FOLDER"
      opts.separator  ""
      opts.separator  "在指定目录下检查header是否依赖外部头文件"
      opts.separator  "原理："
      opts.separator  "在xx.framework/Headers下面扫描每个.h文件的内容，如果发现#import，提取\"header.h\"部分，然后在当前目前查找是否有"
      opts.separator  "此文件，如果没有，则认为该文件为external，需要使用#import <xxx/header.h>方式"

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        self.cmd_options[:verbose] = v
      end
    end
  end

  # parse command line
  def run
    self.cmd_parser.parse!

    if ARGV.length != 1
      puts self.cmd_parser.help
      return
    end

    dir_path = ARGV[0]
    verbose = self.cmd_options[:verbose]

    if !File.directory?(dir_path)
      puts "[Error] #{dir_path} is not a directory!"
      return
    end

    header_paths = []
    Dir.glob(dir_path + '/**/*') do |item|
      next if item == '.' or item == '..'

      if !File.directory?(item) && File.exist?(item)
        if item.end_with?('.h')
          header_paths.push(item)
        end
      end
    end

    header_records = {}
    header_paths.each do |path|
      puts "[verbose] Scanning #{path}".yellow if verbose
      File.open(path, 'r+').each do |line|
        if line.strip.start_with?('#import')
          if line.include?('"') && !line.include?('/')
            linepartition = line.partition(/".*"/)
            if linepartition.length == 3
              # 将在文件中#import "Header.h"的行找到，把 "Header.h" 这一段提取出来
              header = linepartition[1].delete('"')

              next if not header_records[header].nil?

              found_path = check_array_contains_substring(header_paths, header)
              if not found_path.nil?
                header_records[header] = found_path
              else
                puts "Found in #{path}"
                puts "#{header} is external. Change it to #import<xxx/#{header}>".red
              end
            end
          end
        end
      end
    end

  end

  def check_array_contains_substring(strings, substring)
    found_string = nil
    strings.each do |string|
      if (string.include?(substring))
        found_string = string
        break
      end
    end
    found_string
  end
end

FrameworkUtility.new.run
