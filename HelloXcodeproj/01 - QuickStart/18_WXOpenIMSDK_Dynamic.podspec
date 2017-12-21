#
#  Be sure to run `pod spec lint INet.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "WXOpenIMSDK"
  s.version      = "0.0.1"
  s.summary      = "podspec for WXOpenIMSDK_Dynamic"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  podspec for WXOpenIMSDK_Dynamic
                   DESC

  s.homepage     = "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk/"
  s.license      = "MIT"
  s.author       = { "daydreamboy" => "wesley4chen@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk.git", :commit => "dadbb627d51f7138da47a683dd98d304c2b111f1" }
  s.requires_arc = true
  # s.prefix_header_file = "OpenIM-Prefix.h"
  s.prefix_header_contents = '
  #ifdef __OBJC__
    #import "WXOpenIMSDK_Dynamic-Prefix.h"
  #endif
  '
  s.header_dir = 'WXOpenIMSDKFMWK'
  s.source_files  = [
    "WXOpenIMSDK_Dynamic-Prefix.h",
    # source files for WXOpenIMSDK_DelayLoaded
    "WXOpenIMSDK/WXOOptionalModules/WXOCombinedForwardModule/YWExtensionForCombinedForwardLoader.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyCustomize+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOExtensionModule/WXOExtensionServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWConversation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/YWDBMigratorHelper.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOAnonAccountModule/UMUtil/UMUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogUtils.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXODiagnoseModule/WXDiagnoseService.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/YWDBMigrator.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/WXPageAction/YWBridgeContainer.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogService.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOCombinedForwardModule/YWExtensionForCombinedForwardService.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOLoginModule/WXOLoginServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/YWP2PConversation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWProfileManager.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOLogModule/WXOLogServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyVoice+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWBlockDelegate+DelayLoaded.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyCustomizeInternal+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/Actions/YWHandleP2SRequestCASC.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/FileTranProgressDelegation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/YWDBRemoveCipherTransformer.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOUtilModule/WXOUtilServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOUtilModule/WXOUtilServiceImpl4AppMonitor.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOCombinedForwardModule/YWCombinedForwardServiceInternalDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXORoamModule/WXORoamingServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/WXOMessageUpdateManager.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/YWMessageBodyShortVideo+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyVoice.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWSettingModule/YWSettingServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyImage.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWDiskCache/YWDiskCache.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWCacheUtil/YWCacheUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogDiagController.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOUtilModule/WXOAccountUtilService/YWAccountCacheImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyLocation+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/YWAPI+InternalFile.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/Actions/YWActionHelper.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyShortVideo.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWCache.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWProfileDBWrapper.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWHybridModule/YWHybridServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOUTModule/WXOUTServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOPushModule/WXOPushServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOCombinedForwardModule/YWCombinedForwardBodyConverter.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/WXODBServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyImage+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOEHelperModule/WXOEHelperServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/WXOContactServiceImpl+DelayLoaded.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyText+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/YWActionServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWImageLoader.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/WXOMessageBodyP2PInfos+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOCombinedForwardModule/YWCombinedForwardConversation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/YWMessageBodySystemNotify+P2P.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOExtensionModule/IYWExtensionServiceDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXODiagnoseModule/WXDiagnoseService+RegisterCommands.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWProfileDBCache.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWDiskCache/YWMetaDataCache.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLatestLogQueue.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/YWExternalImpl.{h,m,mm,c,cpp}",    
    # source files for WXMessengerKit_DelayLoaded
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/WXManagedObjectContextManager/WXMigrationManager/WXMigrationItem.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/WXManagedObjectContextManager/WXMigrationManager/WXProgressivelyMigrationManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/WXMsgBizLogic+Internal.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/FileTranBiz/WantuUploadeDef.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/FileTranBiz/InterruptedUploadHttpDataRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/OptionalBiz/ISVBiz/WXISVBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/FileTranBiz/WantuUploader.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWConnector/YWHandlerBlockRunner.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/FileTranBiz/WXFileTranService.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWConnector/YWConnector.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/WXMsgBizLogic.{h,m,mm,c,cpp}",   
    # headers
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/headers/**/*.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/WXBizDB.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/Headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOExtensionModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOLogModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWSettingModule/header/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXODiagnoseModule/headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOStructuredLogModule/IWXStructuredLogService.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/Headers/IWXTribeService.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/WXTribeUIDefine.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/TribeMsgHandler.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/TribeBizDB.h",
    "WXOpenIMSDK/WXOCoreModules/WXORoamModule/headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOEHelperModule/Headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/Conversaiton/YWContactSystemConversation.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOUtilModule/public/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWFriend/YWGroup+Internal.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWProfileManager+internal.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/YWTribe+Internal.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/YWTribeMember+Internal.h",
    "WXOpenIMSDK/WXOCoreModules/WXOUTModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOPushModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOTCMSModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/YWCoreDataBridgeable.h",
    "WXOpenIMSDK/WXOCoreModules/WXOSecurityModule/IWXOSecurityService.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/IYWMessageTribe.h",
    "WXOpenIMSDK/WXOCoreModules/YWHybridModule/header/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXORoamModule/IYWRoamingServiceInternal.h",
    # headers (xxx.h) in WangXinKit but use #import <WXOpenIMSDKFMWK/xxx.h> in TBWangXin
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WQConnector/WQConnector.h",
    "WXOpenIMSDK/WXOpenIMSDK/headers/public/YWFMWK.h",
    "WXOpenIMSDK/WXOpenIMSDK_Dynamic/WXOpenIMSDKFMWK.h",
    "WXOpenIMSDK/WXOpenIMSDK/headers/public/YWAPI.h",
    "WXOpenIMSDK/WXOpenIMSDK/headers/public/YWIMCore.h",
    "WXOpenIMSDK/WXOCoreModules/WXOLoginModule/headers/public/IYWLoginService.h",
    "WXOpenIMSDK/WXOCoreModules/WXOLoginModule/headers/public/YWLoginServiceDef.h",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/headers/public/IYWDBService.h",
    "WXOpenIMSDK/WXOCoreModules/YWServerConfigurationModule/headers/public/IYWServerConfigurationService.h",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/YWPredicate.h",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/headers/public/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/headers/public/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/headers/public/IYWActionService.h",
    "WXOpenIMSDK/WXOCoreModules/headers/public/YWServiceDef.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOEHelperModule/Headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOCustomMsgModule/YWCustomConversation.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOCombinedForwardModule/IYWExtensionForCombinedForwardService.h",
    "WXSDK/project/WXModule/include/**/*.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/CommonFunction/CommonFunction.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXWeakRef/WXWeakRef.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXWeakRef/WXWeakDictionary.h",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWModular/YWModular.h",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWConnector/YWConnector.h",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWConnector/YWHandlerBlockRunner.h",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WQConnector/WQConnector.h",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WQConnector/WQEAppClient.h",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WQConnector/WQEAppPermission.h",
    "WXOpenIMSDK/WXOpenIMSDK/headers/public/YWExternalImpl.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXTypeCheck/TypeCheck.h",
    # source added
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWHybridWebView/**/*.{h,m,mm,c,cpp}",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/WQBridgeConfig.h",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWBaseBridgeService.h",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWHybridConnector.{h,m,mm,c,cpp}",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWHybridEngine.{h,m,mm,c,cpp}",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWHybridWebView.{h,m,mm,c,cpp}",
  ]
  s.exclude_files = [
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/OptionalBiz/CaptchaCheckBiz/WXCaptchaCheckBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/OptionalBiz/CaptchaCheckBiz/WXCaptchaCheckResponser.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXPublicConfig/WXPublicConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXUserDefaults/WWDBUserDefaults+CoreDataClass.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXUserDefaults/WWDBUserDefaults+CoreDataProperties.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLinkUrlParser/TBItemLinkParser/TBItemLinkParser.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLinkUrlParser/WXLinkUrlParser.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogDiagController.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/iConsole/iConsole.{h,mm}",
    # "WXSDK/project/WXIMSDKFundamental/3rdParty/Reachability/Reachability.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogUtils.{h,mm}",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/AutoRoamingConfig.{h,m,mm,c,cpp}",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ZipArchive/ZipArchive.{h,mm}",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ZipArchive/minizip/*.{h,c}",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/WXLinkUrlParser/WXLinkUrlParser.{h,m,mm,c,cpp}",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/WXLinkUrlParser/TBItemLinkParser/TBItemLinkParser.{h,m,mm,c,cpp}",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/WXSoundTool/WXSoundTransformViewDemo/**/*",
    # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/Reachability/Reachability.{h,m,mm,c,cpp}",
    # Note: WXMessengerError.h必须物理删除，WXMessengerError.h和.m再同一文件夹下，还是优先当前文件夹
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerError.h",
    # Note: YWExternalImpl.m必须物理删除
    "WXOpenIMSDK/WXOpenIMSDK/headers/public/YWExternalImpl.m",
    "WXOpenIMSDK/WXOCoreModules/CoreDataBridge/YWFetchedResultsController.m",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWConnector/YWConnector.m",
  ]
  # @see https://forum.openframeworks.cc/t/solved-tr1-memory-not-found-on-unit-testing-target-with-xcode-5/18162/2
  s.pod_target_xcconfig = { 
    "CLANG_CXX_LANGUAGE_STANDARD" => "compiler-default",
    "CLANG_CXX_LIBRARY" => "libstdc++", 
    "GCC_PREPROCESSOR_DEFINITIONS" => 'OPENIM DELAY_LOADED',
    "CLANG_ENABLE_OBJC_WEAK" => "YES",
    # @see https://github.com/CocoaPods/CocoaPods/issues/4386
    "HEADER_SEARCH_PATHS" => '"${PODS_ROOT}/../wxopenimsdk/WXSDK/project/tcmpushsdk/inet/inet/common" "${PODS_ROOT}/../wxopenimsdk/WXSDK/project/INet/include"',
    "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/ALBBMediaService" "${PODS_ROOT}/YWAudioKit"',
    "CODE_SIGN_STYLE" => "Automatic",
    "ONLY_ACTIVE_ARCH" => "NO",
  }

  s.xcconfig = {
    "ENABLE_BITCODE" => "NO"
  }

  s.subspec 'no-arc' do |ss|
    ss.requires_arc = false
    ss.source_files = [
      # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXKeyChainUtil/WXKeyChainUtils.m",
      # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDWebDataDownloader.m",
      # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDWebDataManager.m",
      # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogDiagController.m",
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDImageView+WXSDWebCache.m",
      # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDNetworkActivityIndicator.m",
      # "WXSDK/project/WXIMSDKFundamental/3rdParty/Base64/Base64.m",
      "WXSDK/project/WXIMSDKFundamental/3rdParty/JSONKit/JSONKit.m",
      # "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/ZipArchive.mm",
      # "WXSDK/project/WXIMSDKFundamental/3rdParty/Reachability/Reachability.m",
      # "WXSDK/project/IHttp/src/WXHttpRequest/WXTokenHttpRequestManager.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIDownloadCache.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIFormDataRequest.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIDataCompressor.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/WXSDInterruptedWebDataDownloader.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIAuthenticationDialog.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIInputStream.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIDataDecompressor.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASINetworkQueue.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/ASIHTTPRequest/ASIHTTPRequest.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/AddressBookUtils/AddressBookUtils.m",
      # "WXSDK/project/IWangxinExtension/IWangxinExtension/Fundamental/Reachability/Reachability.m",
      # "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/WXNativeSecurity/SecKeyWrapper.m",
      # "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/IOSINetImpl.mm",
      # "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/TCMS4IOS.mm",
      # "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWMemoryCache/YWMemoryCache.m",
      # "WXSDK/project/WXIMSDKFundamental/3rdParty/CocoaAsyncSocket/GCD/GCDAsyncSocket.m",
      # "WXSDK/project/WXIMSDKFundamental/3rdParty/CocoaAsyncSocket/GCD/GCDAsyncUdpSocket.m",
    ]
  end

  s.vendored_frameworks = [
    # "WXSDK/project/WXIMSDKFundamental/Frameworks/ALBBMediaService.framework",
    # "WXSDK/project/WXIMSDKFundamental/Frameworks/SecurityGuardSDK.framework",
    # "WXOpenIMSDK/Framework/YWAudioKit.framework",
    #
    # "WXSDK/project/WXIMSDKFundamental/Frameworks/WQConnector.framework",
    # "WXOpenIMSDK/Framework/YWNotification.framework",
    # "WXOpenIMSDK/Framework/YWHybridWebViewFMWK.framework",
    # "vendor_framework/WQConnector.framework",
    "Vendored_Frameworks/YWNotification.framework",
    # "vendor_framework/UTMini.framework",
    # "vendor_framework/UTDID.framework",
  ]

  s.framework = [
    "AssetsLibrary",
  ]

  # Note: 自动添加lib前缀
  s.libraries = [
    "stdc++.6.0.9",
    "iconv",
    "resolv",
    "z",
  ]

  # Note: https://stackoverflow.com/questions/19481125/add-static-library-to-podspec
  s.subspec 'OpenSSL' do |openssl|
    openssl.preserve_paths = "WXSDK/project/tcmpushsdk/inet/ios/openssl/include/openssl/*.h"
    openssl.vendored_libraries = [
      "WXSDK/project/tcmpushsdk/inet/ios/openssl/lib/libcrypto.a", 
      "WXSDK/project/tcmpushsdk/inet/ios/openssl/lib/libssl.a"
    ]
    openssl.libraries = [
      'ssl', 
      'crypto'
    ]
    openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/../wxopenimsdk/WXSDK/project/tcmpushsdk/inet/ios/openssl/include"' }
  end

  # s.resource_bundle = {
  #   'WXMessengerKitResource' => [
  #     "Assets/Messenger.xcdatamodeld",
  #     "Assets/Messenger.xcdatamodeld/*.xcdatamodel",
  #     "Assets/login_return_code.plist",
  #   ],
  #   'WXOpenIMSDKResource' => [
  #     # Note: empty bundle to embed 'WXMessengerKitResource'
  #   ]
  # }
  
  # s.subspec 'arc' do |ss|
  #   ss.requires_arc = true
  #   ss.source_files = [
  #     "ios-inet/WXMessenger/WXMessengerResponseCenter.mm",
  #     "ios-inet/inet/"
  #   ]
  # end
  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # 
  # 

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # 

end
