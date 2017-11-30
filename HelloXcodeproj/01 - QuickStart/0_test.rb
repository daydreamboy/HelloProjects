require_relative '../02 - Ruby Helper/rubyscript_helper'

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

build_settings = { 'test' => "a" }
key = 'test'
value_to_append = 'something'
default_value = '$(inherit)'

change_build_settings(build_settings, key, value_to_append, default_value)

dump_object(build_settings)
