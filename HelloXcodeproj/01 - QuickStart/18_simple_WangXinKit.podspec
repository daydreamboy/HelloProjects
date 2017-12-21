
Pod::Spec.new do |s|
  s.name         = "WangXinKit"
  s.version      = "0.0.1"
  s.summary      = "podspec for WangXinKit static library."
  s.description  = <<-DESC
  podspec for WangXinKit static library.
                   DESC

  s.homepage     = "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk/"
  s.license      = "MIT"
  s.author       = { "daydreamboy" => "wesley4chen@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk.git", :commit => "dadbb627d51f7138da47a683dd98d304c2b111f1" }
  s.requires_arc = true
  s.prefix_header_contents = '
  #ifdef __OBJC__
    #import "WangXinKit-Prefix.h"
  #endif
  '
  s.source_files  = [
    "WangXinKit-Prefix.h",
  ]
  s.exclude_files = [
    "WangXinKit-exclude_files.{h,m,mm,c,cpp}",
  ]
  s.subspec 'no-arc' do |ss|
    ss.requires_arc = false
    ss.source_files = [
      "WangXinKit-no-arc-source_files",
    ]
  end

  s.subspec 'OpenSSL' do |openssl|
    openssl.preserve_paths = "WangXinKit-OpenSSL-preserve_paths"
    openssl.vendored_libraries = [
      "WangXinKit-OpenSSL-vendored_libraries1", 
      "WangXinKit-OpenSSL-vendored_libraries1",
    ]
    openssl.libraries = [
      'simple_WangXinKit', 
    ]
    openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/../simple_WangXinKit/include"' }
  end
  
  s.subspec 'no-arc2' do |ss|
    ss.requires_arc = false
    ss.source_files = [
      "WangXinKit-no-arc-source_files",
    ]
  end

  s.vendored_frameworks = [
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

  # @see https://forum.openframeworks.cc/t/solved-tr1-memory-not-found-on-unit-testing-target-with-xcode-5/18162/2
  s.xcconfig = { 
    "CLANG_CXX_LANGUAGE_STANDARD" => "compiler-default",
    "CLANG_CXX_LIBRARY" => "libstdc++", 
    "GCC_PREPROCESSOR_DEFINITIONS" => 'OPENIM',
    "CLANG_ENABLE_OBJC_WEAK" => "YES",
    # @see https://github.com/CocoaPods/CocoaPods/issues/4386
    # "HEADER_SEARCH_PATHS" => '"${PODS_ROOT}/../../TBWangxin/wxopenimsdk/WXSDK/project/tcmpushsdk/inet/inet/common" "${PODS_ROOT}/../../TBWangxin/wxopenimsdk/WXSDK/project/INet/include"',
    "FRAMEWORK_SEARCH_PATHS" => "$PODS_CONFIGURATION_BUILD_DIR/WangXinKit",
    "ENABLE_BITCODE" => "NO",
    "ONLY_ACTIVE_ARCH" => "NO",
  }

  s.resource_bundle = {
    'WXMessengerKitResource' => [
      "Assets/Messenger.xcdatamodeld",
      "Assets/Messenger.xcdatamodeld/*.xcdatamodel",
      "Assets/login_return_code.plist",
    ],
    'WXOpenIMSDKResource' => [
      # Note: empty bundle to embed 'WXMessengerKitResource'
    ]
  }
  s.dependency 'AFNetworking', '3.0'
  s.dependency 'ReactiveCococa', '~>2.0'
end
