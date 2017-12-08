
path = './2.txt'
build_settings = Hash[*File.read(path).lines.map{|x| x.split(/\s*=\s*/, 2)}.flatten]
if build_settings['FRAMEWORK_SEARCH_PATHS']
  arr = build_settings['FRAMEWORK_SEARCH_PATHS'].split
  arr.each do |line|
    puts line
  end
end