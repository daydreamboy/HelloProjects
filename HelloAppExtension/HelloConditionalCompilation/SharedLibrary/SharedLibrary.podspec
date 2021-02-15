#
#  Be sure to run `pod spec lint SharedLibrary.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "SharedLibrary"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of SharedLibrary."

  spec.description  = <<-DESC
  This pod is shared between app and app extension. Demonstrate the conditional compilation for app extension
                   DESC

  spec.homepage     = "http://some-domain/SharedLibrary"

  spec.license      = "MIT"

  spec.author             = { "daydreamboy" => "wesley4chen@gmail.com" }

  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "http://some-domain/SharedLibrary.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  spec.pod_target_xcconfig = { 
    "_APP_EXTENSION_GCC_YES" => "1",
    "_APP_EXTENSION_GCC_NO" => "0",
    "BUILDING_FOR_APP_EXTENSION" => "$(_APP_EXTENSION_GCC_$(APPLICATION_EXTENSION_API_ONLY))",
    "APP_EXTENSION_GCC" => "BUILDING_FOR_APP_EXTENSION",
    "GCC_PREPROCESSOR_DEFINITIONS" => "$(inherited) $(APP_EXTENSION_GCC)",
  }

end
