require 'xcodeproj'

# Note: get xcuserdata folder
# project_path = './Sample/Sample.xcodeproj'
project_path = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods/Pods.xcodeproj'
xcuserdata = Xcodeproj::XCScheme.user_data_dir(project_path).to_path

extension = ".xcscheme"

xcschememanagement_plist = "xcschememanagement.plist"

# Note: get all .xcscheme files
puts "all schemes: "
Dir.foreach(xcuserdata) { |file|
  if file.end_with?(extension)
    puts File.basename(file, extension)
  end
}

scheme_name = "Framework.xcscheme"

puts "#{xcschememanagement_plist} dict: "

# Note: read xcschememanagement.plist
xcschememanagement_plist_path = File.join(xcuserdata, xcschememanagement_plist)
dict = Xcodeproj::Plist.read_from_path(xcschememanagement_plist_path)

puts "before change: #{dict}"

has_changed = false
dict.each { |key, value|
  if key == "SchemeUserState"
    attributes = value[scheme_name]
    if !attributes.nil?
      attributes["isShown"] = true
      has_changed = true
      break
    end
  end
}

puts "after change: #{dict}"

# Note: write back to plist if changed
if has_changed
  Xcodeproj::Plist.write_to_path(dict, xcschememanagement_plist_path)
end


