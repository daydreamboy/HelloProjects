#encoding: utf-8

require_relative '../02 - Ruby Helper/rubyscript_helper'
require 'fileutils'

dir_path = '/Users/wesley_chen/Library/Caches/CocoaPods/Pods-1.2.0/Release'

# @see https://stackoverflow.com/questions/2370702/one-liner-to-recursively-list-directories-in-ruby
Dir.glob(dir_path + '/*') do |item|
  next if item == '.' or item == '..'

  # @see https://stackoverflow.com/questions/10115591/check-if-a-filename-is-a-folder-or-a-file
  if File.directory?(item) && File.exist?(item)
    version_caches = Dir.glob(item + '/*')

    # Note: only have multiple versions of cache
    if version_caches.length > 1

      # Note: sort by create time, the latest the first
      # @see https://stackoverflow.com/questions/15401061/custom-sort-method-in-ruby
      version_caches.sort! do |a, b|
        case
          when File.ctime(a) > File.ctime(b)
            -1 # [a, b]
          when File.ctime(a) < File.ctime(b)
            1 # [b, a]
          else
            0 # a == b
        end
      end

      # Note: remove first cache because it's latest
      version_caches.delete_at(0)

      version_caches.each do |version_cache|
        puts "Removing folder `#{version_cache}`"
        # @see https://stackoverflow.com/questions/12335611/ruby-deleting-directories
        FileUtils.rm_rf(version_cache)
      end

    end
  end
end