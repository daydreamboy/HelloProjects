require_relative '../02 - Ruby Helper/rubyscript_helper'

gem_list = %w(colored2 logger)

gem_list.each do |gem_name|
  # @see https://stackoverflow.com/questions/22211711/how-to-check-if-a-gem-is-installed
  is_installed = `gem list -i #{gem_name}`.strip
  if is_installed == 'false'
    puts "[Error] gem `#{gem_name}` not found. Please install it by `gem install #{gem_name}`"
  end
end

