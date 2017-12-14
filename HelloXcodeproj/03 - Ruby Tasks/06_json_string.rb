require 'json'

string = '{"git":"git@gitlab.alibaba-inc.com:wx-ios/wxopenimsdk.git","branch":"feature/171115/pod","commit":"12ab","tag":"0.0.1","podspecs":{"WXOpenIMSDK":{"path":"./wxopenimsdk/22_WXOpenIMSDK_Dynamic.podspec","use_framework":true},"WangXinKit":{"path":"./wxopenimsdk/22_WangXinKit.podspec","use_framework":true,"is_dynamic":false}}}'

# PodInfo's all configurations as follows:
$json_string = '
{
    "git": "git@gitlab.alibaba-inc.com:wx-ios/wxopenimsdk.git",
    "branch": "feature/171115/pod",
    "commit": "12ab",
    "tag": "0.0.1",
    "podspecs": {
        "WXOpenIMSDK": {
            "path": "./wxopenimsdk/22_WXOpenIMSDK_Dynamic.podspec",
            "use_framework": true,
            "run_script_paths": "${PROJECT_DIR}/../wxopenimsdk/Scripts/create_universal_framework.sh",
            "product_name": "WXOpenIMSDKFMWK",
            "build_settings": {
                "ENABLE_STRICT_OBJC_MSGSEND": "NO"
            }
        },
        "WangXinKit": {
            "path": "./wxopenimsdk/22_WangXinKit.podspec",
            "use_framework": true,
            "is_dynamic": false,
            "run_script_paths": [
                "${PROJECT_DIR}/../wxopenimsdk/Scripts/copy_resource_bundle_to_WangXinKit_framework.sh",
                "${PROJECT_DIR}/../wxopenimsdk/Scripts/create_universal_framework.sh"
            ]
        }
    }
}
'

json_object = JSON.parse($json_string)

translated_json_string = JSON.dump(json_object).gsub!(',', ';')
puts translated_json_string