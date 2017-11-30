require_relative '../02 - Ruby Helper/rubyscript_helper'

# Configurations
pod_name = 'AwesomeSDK_dynamic_framework'
main_target_name = 'AwesomeSDK_Example'
pods_dir = '/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloCocoaPods/HelloCocoaPods-StaticLibraryIntegration/AwesomeSDK/Example/Pods'

install_frameworks_script_name = 'Pods-' + main_target_name + '-frameworks.sh'
path_of_install_frameworks_script = File.join(pods_dir, 'Target Support Files', 'Pods-' + main_target_name, install_frameworks_script_name)
insert_text = '  install_framework "${BUILT_PRODUCTS_DIR}/' + pod_name + '/' + pod_name + '.framework"' + "\n"


# @see https://stackoverflow.com/a/150111
if_block_start_for_debug = 'if [[ "$CONFIGURATION" == "Debug" ]]; then'
if_block_start_for_release = 'if [[ "$CONFIGURATION" == "Release" ]]; then'
if_block_end = 'fi'

insert_text_before_this_line = '
if [ "${COCOAPODS_PARALLEL_CODE_SIGN}" == "true" ]; then
  wait
fi'


def insert_text(file_content, reg, insert_text, if_block_start, if_block_end, insert_text_before_this_line)
  extracted_if_body_for_debug = file_content[reg, 1]

  # 如果没有if语句
  if extracted_if_body_for_debug.nil?
    index = file_content.index(insert_text_before_this_line)

    if index.nil?
      raise('not found ' + insert_text_before_this_line)
    else
      replacement = "\n" + if_block_start + "\n" + insert_text + if_block_end

      first_part = file_content[0, index]
      second_part = file_content[index.. -1]
      file_content = first_part + replacement + second_part
    end

  else
    # 如果if body没有包含insert_text
    if !extracted_if_body_for_debug.include?(insert_text)

      replacement = if_block_start + extracted_if_body_for_debug + insert_text + if_block_end
      file_content.gsub!(reg, replacement)

    end
  end

  return file_content

end


if File.exists?(path_of_install_frameworks_script)

  file_content = File.read(path_of_install_frameworks_script)

  # @see https://stackoverflow.com/a/8075288
  # @see .+?, https://stackoverflow.com/questions/1919982/regex-smallest-possible-match-or-nongreedy-match
  reg1 = Regexp.new("#{Regexp.escape(if_block_start_for_debug)}(.+?)#{Regexp.escape(if_block_end)}", Regexp::MULTILINE)
  reg2 = Regexp.new("#{Regexp.escape(if_block_start_for_release)}(.+?)#{Regexp.escape(if_block_end)}", Regexp::MULTILINE)

  file_content = insert_text(file_content, reg1, insert_text, if_block_start_for_debug, if_block_end, insert_text_before_this_line)
  file_content = insert_text(file_content, reg2, insert_text, if_block_start_for_release, if_block_end, insert_text_before_this_line)

  File.write(path_of_install_frameworks_script, file_content)

end

