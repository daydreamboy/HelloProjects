

attr = '$(inherited) $(PODS_ROOT)/UTDID $PODS_CONFIGURATION_BUILD_DIR/WangXinKit "${PODS_ROOT}/ALBBMediaService" "${PODS_ROOT}/NetworkSDK" "${PODS_ROOT}/SGIndieKit" "${PODS_ROOT}/SGMain" "${PODS_ROOT}/SGSecurityBody" "${PODS_ROOT}/SecurityGuardSDK" "${PODS_ROOT}/TBSecuritySDK" "${PODS_ROOT}/UTDID" "${PODS_ROOT}/UserTrack" "${PODS_ROOT}/../wxopenimsdk/Vendored_Frameworks" "${PODS_ROOT}/WindVane" "${PODS_ROOT}/YWAudioKit" "${PODS_ROOT}/ZipArchive" "${PODS_ROOT}/tnet"'
list_to_remove = nil
list_to_add = ['$PODS_CONFIGURATION_BUILD_DIR/WangXinKit']

parts = attr.split

# @see https://stackoverflow.com/questions/30276873/ruby-wrap-each-element-of-an-array-in-additional-quotes
parts.map! do |item|
  item.gsub!(/\A"|"\z/,'')
  item.gsub!(/\A'|'\z/,'')
  item
end.reject! do |item|
  if list_to_remove.nil?
    false
  else
    list_to_remove.include? item
  end
end

if !list_to_add.nil?
  parts = parts + list_to_add
end

parts.map! do |item|
  if item != '$(inherited)'
    '"' + item + '"'
  else
    item
  end
end

puts parts

