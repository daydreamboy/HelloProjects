
Pod::Spec.new do |s|
  s.name         = "WXOpenIMSDK"
  s.version      = "0.0.1"
  s.summary      = "podspec for WXOpenIMSDK_Dynamic"
  s.description  = <<-DESC
  podspec for WXOpenIMSDK_Dynamic
                   DESC

  s.homepage     = "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk/"
  s.license      = "MIT"
  s.author       = { "daydreamboy" => "wesley4chen@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk.git", :commit => "dadbb627d51f7138da47a683dd98d304c2b111f1" }
  s.requires_arc = true
  s.prefix_header_contents = '
  #ifdef __OBJC__
    #import "WXOpenIMSDK_Dynamic-Prefix.h"
  #endif
  '
  s.header_dir = 'WXOpenIMSDKFMWK'
  s.source_files  = [
    "WXOpenIMSDK_Dynamic-Prefix.h",
  ]
  s.exclude_files = [
    "WXOpenIMSDK_Dynamic-exclude_files",
  ]
  s.pod_target_xcconfig = { 
    "CLANG_CXX_LANGUAGE_STANDARD" => "compiler-default",
    "CLANG_CXX_LIBRARY" => "libstdc++", 
    "GCC_PREPROCESSOR_DEFINITIONS" => 'OPENIM DELAY_LOADED',
    "CLANG_ENABLE_OBJC_WEAK" => "YES",
    "HEADER_SEARCH_PATHS" => '"${PODS_ROOT}/../wxopenimsdk/WXSDK/project/tcmpushsdk/inet/inet/common" "${PODS_ROOT}/../wxopenimsdk/WXSDK/project/INet/include"',
    "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/ALBBMediaService" "${PODS_ROOT}/YWAudioKit"',
    "CODE_SIGN_STYLE" => "Automatic",
    "ONLY_ACTIVE_ARCH" => "NO",
  }

  s.xcconfig = {
    "ENABLE_BITCODE" => "NO",
	"FRAMEWORK_SEARCH_PATHS" => "$PODS_CONFIGURATION_BUILD_DIR/WXOpenIMSDK",
  }

  s.subspec 'no-arc' do |ss|
    ss.requires_arc = false
    ss.source_files = [
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDImageView+WXSDWebCache.m",
      "WXSDK/project/WXIMSDKFundamental/3rdParty/JSONKit/JSONKit.m",
    ]
  end

  s.vendored_frameworks = [
    "Vendored_Frameworks/YWNotification.framework",
  ]

  s.framework = [
    "AssetsLibrary",
  ]

  s.libraries = [
    "stdc++.6.0.9",
    "iconv",
    "resolv",
    "z",
  ]

  s.subspec 'OpenSSL' do |openssl|
    openssl.preserve_paths = "WXSDK/project/tcmpushsdk/inet/ios/openssl/include/openssl/*.h"
    openssl.vendored_libraries = [
      "WXSDK/project/tcmpushsdk/inet/ios/openssl/lib/libcrypto.a", 
      "WXSDK/project/tcmpushsdk/inet/ios/openssl/lib/libssl.a"
    ]
    openssl.libraries = [
      'ssl', 
      'crypto',
      'blah'
    ]
    openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/../wxopenimsdk/WXSDK/project/tcmpushsdk/inet/ios/openssl/include"' }
  end
end
