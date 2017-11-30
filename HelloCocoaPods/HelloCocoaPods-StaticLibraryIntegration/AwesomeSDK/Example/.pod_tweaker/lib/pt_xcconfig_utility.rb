require 'pt_pod_utility'

def change_xcconfig_of_main_target(target, dynamic_framework_pod_list, static_framework_pod_list)

  target.build_configurations.each do |config|
    xcconfig_path = config.base_configuration_reference.real_path

    # @see cocoapods-post-install.rb in TBWangXin
    build_settings = Hash[*File.read(xcconfig_path).lines.map{|x| x.split(/\s*=\s*/, 2)}.flatten]

    other_ldflags = build_settings['OTHER_LDFLAGS']
    if other_ldflags
      other_ldflags = remove_ldflags_for_dynamic_framework(other_ldflags, dynamic_framework_pod_list)
      other_ldflags = change_ldflags_for_static_framework(other_ldflags, static_framework_pod_list)

      build_settings['OTHER_LDFLAGS'] = other_ldflags
    end

    build_settings['OTHER_LDFLAGS'] = other_ldflags
    build_settings = change_settings_for_static_framework(build_settings, static_framework_pod_list)
    build_settings = change_settings_for_dynamic_framework(build_settings, dynamic_framework_pod_list)

    # write build_settings dictionary to xcconfig
    File.open(xcconfig_path, 'w')
    build_settings.sort.to_h.each do |key,value|
      File.open(xcconfig_path, 'a') {|file| file.puts "#{key} = #{value}"}
    end

  end
end

def remove_ldflags_for_dynamic_framework(other_ldflags, dynamic_framework_pod_list)
  retVal = other_ldflags
  dynamic_framework_pod_list.each do |pod_name|

    ldflags_opt_to_remove = "-l\"#{pod_name}\""

    # remove the unwanted -l"xxx"
    if other_ldflags.include? ldflags_opt_to_remove
      index = other_ldflags.index(ldflags_opt_to_remove)
      length = ldflags_opt_to_remove.length
      first_path = other_ldflags[0, index]
      last_path = other_ldflags[index + length .. -1]
      exclude_ldflags = first_path + last_path
      # collapse whitespace
      exclude_ldflags = exclude_ldflags.split.join(' ')

      retVal = exclude_ldflags
    end
  end

  return retVal
end

def change_ldflags_for_static_framework(other_ldflags, static_framework_pod_list)
  retVal = other_ldflags
  static_framework_pod_list.each do |pod_name|
    ldflags_opt_to_modify = "-l\"#{pod_name}\""

    # change the -l"xxx" to -framework "xxx"
    if other_ldflags.include? ldflags_opt_to_modify
      other_ldflags.sub!(ldflags_opt_to_modify, "-framework \"#{pod_name}\"")
    end

  end

  return retVal
end

def change_settings_for_static_framework(build_settings, static_framework_pod_list)
  retVal = build_settings

  static_framework_pod_list.each do |pod_name|
    default_value = '$(inherited) ' + "\"$PODS_CONFIGURATION_BUILD_DIR/#{pod_name}\""
    value_to_append = "\"$PODS_CONFIGURATION_BUILD_DIR/#{pod_name}\""
    change_build_settings(retVal, 'FRAMEWORK_SEARCH_PATHS', value_to_append, default_value)
  end

  return retVal
end

def change_settings_for_dynamic_framework(build_settings, dynamic_framework_pod_list)
  retVal = build_settings

  dynamic_framework_pod_list.each do |pod_name|
    default_value = '$(inherited) ' + "\"$PODS_CONFIGURATION_BUILD_DIR/#{pod_name}\""
    value_to_append = "\"$PODS_CONFIGURATION_BUILD_DIR/#{pod_name}\""
    change_build_settings(retVal, 'FRAMEWORK_SEARCH_PATHS', value_to_append, default_value)
  end

  return retVal
end

# Helpers

def change_build_settings(build_settings, key, value_to_append, default_value)
  value = build_settings[key]

  if value
    if !value.include? value_to_append
      arr = value.split
      arr.push(value_to_append)
      value = arr.join(' ')
    end
  else
    value = default_value
  end

  build_settings[key] = value
end
