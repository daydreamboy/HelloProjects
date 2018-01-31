require 'json'

def json_string_for_WangXinKit_WXOpenIMSDK_Dynamic_WXOpenIMUIKit_Dynamic

  # PodInfo's all configurations as follows:
  $json_string = '
  {
      "podspecs": {
          "WXOpenIMSDK": {
              "path": "../WXOpenIMSDK_Dynamic.podspec",
              "use_framework": true,
              "run_script_paths": "${PROJECT_DIR}/../../Scripts/create_universal_framework.sh",
              "product_name": "WXOpenIMSDKFMWK",
              "build_settings": {
                  "ENABLE_STRICT_OBJC_MSGSEND": "NO"
              }
          },
          "WangXinKit": {
              "path": "../WangXinKit.podspec",
              "use_framework": true,
              "is_dynamic": false,
              "run_script_paths": [
                  "${PROJECT_DIR}/../../Scripts/copy_resource_bundle_to_WangXinKit_framework.sh",
                  "${PROJECT_DIR}/../../Scripts/create_universal_framework.sh"
              ]
          },
          "WXOpenIMUIKit": {
              "path": "../WXOpenIMUIKit_Dynamic.podspec",
              "use_framework": true,
              "product_name": "WXOUIModule",
              "run_script_paths": [
                  "${PROJECT_DIR}/../../Scripts/copy_resource_bundle_to_WXOUIModule_framework.sh",
                  "${PROJECT_DIR}/../../Scripts/create_universal_framework.sh"
              ],
              "dependencies": [ "WXOpenIMSDK" ]
          }
      }
  }
  '

  json_object = JSON.parse($json_string)

  translated_json_string = JSON.dump(json_object).gsub!(',', ';')
  puts "PodInfo='#{translated_json_string}'"
end

def json_string_for_WXOpenIMSDKStatic

  # PodInfo's all configurations as follows:
  $json_string = '
  {
      "git": "git@gitlab.alibaba-inc.com:wx-ios/wxopenimsdk.git",
      "branch": "feature/171115/pod",
      "commit": "12ab",
      "tag": "0.0.1",
      "podspecs": {
          "WXOpenIMSDKStatic": {
              "include_podspecs": [
                "./wxopenimsdk/WXOpenIMSDK_Dynamic.podspec",
                "./wxopenimsdk/WangXinKit.podspec"
              ],
              "use_framework": true,
              "is_dynamic": false,
              "run_script_paths": [
                "${PROJECT_DIR}/../wxopenimsdk/Scripts/copy_resource_bundle_to_WXOpenIMSDKFMWK_framework.sh",
                "${PROJECT_DIR}/../wxopenimsdk/Scripts/create_universal_framework.sh"
              ],
              "product_name": "WXOpenIMSDKFMWK",
              "build_settings": {
                  "ENABLE_STRICT_OBJC_MSGSEND": "NO"
              },
              "post_handler_on_merge": "lambda{|attributes|attributes[\"pod_target_xcconfig\"][\"GCC_PREPROCESSOR_DEFINITIONS\"]=\"OPENIM\"}"
          }
      }
  }
  '

  json_object = JSON.parse($json_string)

  translated_json_string = JSON.dump(json_object).gsub!(',', ';')
  puts "PodInfo='#{translated_json_string}'"
end

def json_string_for_JiaYi1

  # PodInfo's all configurations as follows:
  $json_string = '
  {
      "git": "git@gitlab.alibaba-inc.com:wxlib/ywimbridge.git",
      "branch": "develop",
      "podspecs": {
          "YWIMBridge": {
              "use_framework": true,
              "is_dynamic": false
          }
      }
  }
  '

  json_object = JSON.parse($json_string)

  translated_json_string = JSON.dump(json_object).gsub!(',', ';')
  puts "PodInfo='#{translated_json_string}'"
end

def json_string_for_JiaYi2

  # PodInfo's all configurations as follows:
  $json_string = '
  {
      "podspecs": {
          "YWIMBridge": {
              "use_framework": true,
              "is_dynamic": false,
              "path": "../ywimbridge.podspec",
              "subspecs": ["Core", "Weex", "WebView", "Windvane"]
          }
      }
  }
  '

  json_object = JSON.parse($json_string)

  translated_json_string = JSON.dump(json_object).gsub!(',', ';')
  puts "PodInfo='#{translated_json_string}'"
end


def json_string_for_temp1

  # PodInfo's all configurations as follows:
  $json_string = '
  {
      "podspecs": {
          "WangXinKit": {
              "use_framework": true,
              "is_dynamic": false,
              "path": "../WangXinKit.podspec"
          }
      }
  }
  '

  json_object = JSON.parse($json_string)

  translated_json_string = JSON.dump(json_object).gsub!(',', ';')
  puts "PodInfo='#{translated_json_string}'"
end


# Test Methods
#
json_string_for_WangXinKit_WXOpenIMSDK_Dynamic_WXOpenIMUIKit_Dynamic
# json_string_for_WXOpenIMSDKStatic

# json_string_for_JiaYi1
# json_string_for_JiaYi2
# json_string_for_temp1








