# Pass shell variable (JSON string) to ruby script
# 
# Usage:
#   export PodInfo='{"git":"git@gitlab.alibaba-inc.com:wx-ios/wxopenimsdk.git","branch":"feature/171115/pod","commit":"12ab","podspecs":{"WXOpenIMSDK":{"path":"./wxopenimsdk/WXOpenIMSDK_Dynamic.podspec","use_framework":"true"},"WangXinKit":{"path":"./wxopenimsdk/WangXinKit.podspec","use_framework":"true","is_dynamic":"fase"}}}'
#
# Demo ouput:
#   Ruby hash object
# 
# Reference:
#   @see https://stackoverflow.com/questions/5410682/parsing-a-json-string-in-ruby

require 'json'

env_key = 'PodInfo'
env_value = ENV[env_key]

# env_value = '
# {
#     "git": "git@gitlab.alibaba-inc.com:wx-ios/wxopenimsdk.git",
#     "branch": "feature/171115/pod",
#     "commit": "12ab",
#     "podspecs": {
#         "WXOpenIMSDK": {
#             "path": "./wxopenimsdk/WXOpenIMSDK_Dynamic.podspec",
#             "use_framework": "true"
#         },
#         "WangXinKit": {
#             "path": "./wxopenimsdk/WangXinKit.podspec",
#             "use_framework": "true",
#             "is_dynamic": "false"
#         }
#     }
# }
# '

if !env_value.nil?
  puts "#{env_key} = #{env_value}"
  pod_info = JSON.parse(env_value)
  puts pod_info
else
  puts "not set #{env_key} environment variable"
end
