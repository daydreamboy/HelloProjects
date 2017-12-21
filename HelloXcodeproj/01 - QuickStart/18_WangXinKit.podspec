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

  s.name         = "WangXinKit"
  s.version      = "0.0.1"
  s.summary      = "podspec for WangXinKit static library."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  podspec for WangXinKit static library.
                   DESC

  s.homepage     = "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk/"
  s.license      = "MIT"
  s.author       = { "daydreamboy" => "wesley4chen@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "http://gitlab.alibaba-inc.com/wx-ios/wxopenimsdk.git", :commit => "dadbb627d51f7138da47a683dd98d304c2b111f1" }
  s.requires_arc = true
  # s.prefix_header_file = "OpenIM-Prefix.h"
  s.prefix_header_contents = '
  #ifdef __OBJC__
    #import "WangXinKit-Prefix.h"
  #endif
  '
  # s.header_dir = 'WXOpenIMSDKFMWK'
  s.source_files  = [
    "WangXinKit-Prefix.h",
    # source files for WXOpenIMSDK
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/YWDBLightweightMigrator.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/YWAPI+InternalFile.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/WXMessageBody.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/WXModel+IYWDBModel.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWConversationUnsupported.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOSecurityModule/WXOSecurityServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOLoginModule/WXOLoginServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/IYWTribeServiceDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodySystemNotify.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWConversation+Internal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/YWTribe.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBody+Internal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyUnsupported.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/WXOMessageObject.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOSecurityModule/WXOpenIMSDKEncryptor.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWServiceDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWMessageBodyText+Internal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/YWPredicate.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOPerson/PersonOnlineStatusBlockArray.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/YWAPI.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/YWDBServiceDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWServerConfigurationModule/YWServerConfigurationServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyShortVideo+Internal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyShortVideo.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/P2P/YWP2PConversation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOConversationUtilImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWServiceDef+Internal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/YWIMCore.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyTemplate.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/YWIMCore+InternalService.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOLoginModule/YWLoginServiceDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWFriend/YWGroup.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/YWTribeMember.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyLocation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWFriend/YWBlockDelegate.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOStructuredLogModule/WXStructuredLogService.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWConversation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOPerson/WXOPerson+InternalFile.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/WXOMessageUpdateManager.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyCustomize.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/Actions/YWActionHandlerWangxs.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWMemoryCache/YWMemoryCache.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOConversationServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyP2PInfos.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyVoice.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyImage.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/WXOContactServiceImpl.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyImage+Internal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyCustomizeInternal.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOOptionalModules/WXOCustomMsgModule/YWCustomConversation.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/WXOMessageUtility.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/YWFetchedResultsController.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBody.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOPerson/YWPerson.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOpenIMSDK/WXOpenIMMessageFilter.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/Categories/WXOMessageObject+YWCoreDataBridgeable.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWExternVariables.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/headers/private/YWDBServiceDef+InternalService.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyText.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/Categories/YWConversation+YWCoreDataBridgeable.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/YWConversationServiceDef.{h,m,mm,c,cpp}",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodyFileTrans.{h,m,mm,c,cpp}",   
    # source files for WXMessengerKit_OpenIM
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/TokenBiz/WXTokenService.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Model/HttpModel/HTTPRequest/ITTDataRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/CommonFunction/CommonFunction.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXEncrptDataAccessUtil/WXEncryptDataAccessUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXBroadcastConfig/WXBroadcastConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXUserConfig/WXUserConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXPriorityDelegateContainer/WXPriorityDelegateContainer.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDWebDataManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/ZipArchive.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/WXMsgBizLogic+Internal.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/NotifyDispatchBiz/WXNotifyDispatch/WXNotifyDispatcher.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXAMRCodec.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXBlockObject/WXBlockObject.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/CoreDataExtension/NSEntityDescription+Exception.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/MultiAccountSupportBase/WXOMultiAccountManager/WXOAccountContext.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXBlockContainer/WXBlockContainer.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/LoginBiz/WXLoginBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/Defines/WXClientUtils/WXClientUtils.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXUserDefaults/WXUserDefaults.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXLoginConfig/SDK/WXLoginConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/Defines/WXClientUtils/WXClientUtils+SizeUtils.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/UserInfoBiz/WXUserInfoService.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/MultiAccountSupportBase/SDKExt/WXOAccountContext+BizLogicContext.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/Base64/Base64.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/CoreDataExtension/NSManagedObjectContext+Exception.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXTypeCheck/TypeCheck.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/MsgBizCache.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXWeakRef/WXWeakDictionary.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/minizip/zip.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSData+WXCrypt.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/minizip/unzip.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/MsgBizDB.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/MsgBizHelper.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSData+WXImageType.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXKeyDataUtil/WXKeyDataUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/WXContextBindingObject.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/WXMsgBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/MultiAccountSupportBase/WXOMultiAccountManager/WXOAccountContext+HttpManagerDelegate.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/TokenBiz/WXTokenBizLogicResponser.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXWeakRef/WXWeakRef.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKWXClient/CoreBiz/LoginBiz/WXLoginService+WXClient.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/YWZipArchive+Directory.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKExt/CoreBiz/UserInfoBiz/WXUserInfoService+SDKExt.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/MultiAccountSupportBase/WXOServiceImpl/WXOHttpServiceImpl.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/OptionalBiz/ISVBiz/WXISVBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKExt/CoreBiz/LoginBiz/WXLoginService+SDKExt.{h,m,mm,c,cpp}",
    "WXSDK/project/Defines/HttpTypes/WXHttpRequestTypes.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/DataModel/WXModel.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/WXTribeDefine.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXEncryptor/WXEncryptor.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXRegex/WXRegex.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXPriorityItemContainer/WXPriorityItemContainer.{h,m,mm,c,cpp}",
    "WXSDK/project/Defines/MessengerDefine/MessengerSiteDefine.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDWebDataDownloader.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/Reachability/Reachability.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/OfflineMsgBiz/OfflineMsgBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXEncryptor/WXDecryptCacheQueue.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/LoginBiz/WXLoginService.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSData+WXmd5.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ReadTimeBiz/ReadTimeLogicBiz.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXImageMsgPreviewUrlManager/WXImageMsgPreviewUrlManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDImageView+WXSDWebCache.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/WXManagedObjectContextManager/WXManagedObjectContextManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/WXMsgBizLogic+NotifyDispatcher.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/TokenBiz/TokenLogicBiz.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXLoginConfig/SDK+Ext/WXLoginConfig+SDKExt.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/minizip/mztools.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/src/CoreDataExtension/NSFetchedResultsController+Exception.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/UIImage+WXScale.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/SessionBiz/WXSessionService.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSString+WXmd5.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/JSONKit/JSONKit.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXLoginConfig/WXClient/WXLoginConfig+WXClient.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSData+WXGif.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/WXBizLogicResponserBase.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/MultiAccountSupportBase/WXOMultiAccountManager/WXOMultiAccountManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSString+CDNImageUrl/NSString+WXCDNImageUrl.{h,m,mm,c,cpp}",
    "WXSDK/project/Defines/WXClientUtils/WXClientUtils+ImageUtils.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDDataCache.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLRUCache/WXLRUCache.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXImageMsgPreviewUrlManager/WXImageMsgUrlManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSBundle+ExtensionsWx.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDNetworkActivityIndicator.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/minizip/ioapi.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/MsgBiz/MsgAlertBizLogic/MsgAlertBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXLoginConfig/Static/WXLoginConfig_Static.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXKeyChainUtil/WXKeyChainUtils.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/Category/NSString+WXUrl.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXPerformanceMonitor/WXPerformanceMonitor.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWModular/YWModular.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WXGCDThreadCheck/WXGCDThreadCheck.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/WXMessageFilterProtocal.{h,m,mm,c,cpp}",  
    # source files for INet_EHelper
    "WXSDK/project/INet/include/**/*.h",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessenger+EHelper.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/improtocol/ehelper_pack.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/INet_EHelper/INet_EHelper.{h,m,mm,c,cpp}",
    # source files for INet_OpenIM
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/**/*.h",
    "WXSDK/project/tcmpushsdk/inet/inet/inetcore/**/*.h",
    "WXSDK/project/tcmpushsdk/inet/inet/im/improtocol/**/*.h",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerTypes/WXMessengerContactsTypes.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/inetcore/lock.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/InetString.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/WXNativeSecurity/SecKeyWrapper.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/inetcore/dns.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/common/CipherHelper.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerResponseCenter.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/improtocol/msc_head.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/inet/IMNetCallService.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/inetcore/string_tool.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/TCMStoreManager.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/imcore/WXContext.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/common/commutils.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/inetcore/inetexception.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/imcore/IMService.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/imcore/inetimpl.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerResponser.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerNotifyCenter.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/improtocol/im_pack.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerHelper.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/inetcore/memfile.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXURLUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/json/cJSON.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/InetTimer.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/improtocol/openim_pack.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/WXNativeStore/WXNativeStore.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/im/imcore/protocmdheader.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/WXNativeSecurity/WXNativeSecurity.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerTypes/WXMessengerMsgNSTypes.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerTCPRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/TCMS4IOSUtils.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/WXNativeStore/WXNativeStore+TCMKVStore.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXCppUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/CommonUtil.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/inet/IMNetService4iOS.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/log.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/ios/CipherHelper/iCipherHelper.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/urlencode.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/InetNotification.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/IOSINetImpl.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerError.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/common/AndiosPort.{h,m,mm,c,cpp}",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessenger.{h,m,mm,c,cpp}",
    # source files for IConfig_OpenIM
    "WXSDK/project/IConfig/include/**/*.h",
    "WXSDK/project/IConfig/src/WangXinKitConfig+Internal.{h,m,mm,c,cpp}",
    "WXSDK/project/IConfig/src/WXVersionConfig/WXVersionConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/IConfig/src/WXServerConfig/WXServerConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/IConfig/src/WangXinKitConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/IConfig/src/WXAccountConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/IConfig/src/WXIntraNetConfig/WangXinNetConfig.{h,m,mm,c,cpp}", 
    # source files for IRoaming_OpenIM
    "WXSDK/project/IRoaming/include/**/*.h",
    "WXSDK/project/IRoaming/src/WXRoamingResultHandlerProtocal.{h,m,mm,c,cpp}",
    "WXSDK/project/IRoaming/src/WXRoamingConfig.{h,m,mm,c,cpp}",
    "WXSDK/project/IRoaming/src/WXRoamingTCPRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/IRoaming/src/WXRoamingBizLogicV2.{h,m,mm,c,cpp}",
    "WXSDK/project/IRoaming/src/WXRoamingResultHandler.{h,m,mm,c,cpp}",
    "WXSDK/project/IRoaming/src/WXRoamingConstDef.{h,m,mm,c,cpp}",
    "WXSDK/project/IRoaming/src/WXRoamingTimeLine.{h,m,mm,c,cpp}",
    # source files for IHttp_OpenIM
    "WXSDK/project/IHttp/include/**/*.h",
    "WXSDK/project/IHttp/src/WXHttpRequest/httpUtil/HttpConnetionFactory.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/httpUtil/NSURLHttpConnection.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXHttpTokenManager.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXBizTokenHttpRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/ITTRequestResult.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXWebTokenHttpRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/httpUtil/HELPHttpConnection.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXTokenHttpRequestManager.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXHttpManager.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXTokenHttpRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/httpUtil/HttpLogFactory.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXStringHttpRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/httpUtil/BaseHttpConnection.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXHttpRequest.{h,m,mm,c,cpp}",
    "WXSDK/project/IHttp/src/WXHttpRequest/WXRawHttpRequest.{h,m,mm,c,cpp}",
    # source files for ICoreData_OpenIM
    "WXSDK/project/ICoreData/include/**/*.h",
    "WXSDK/project/ICoreData/src/CoreDataModel/Location.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWMessage.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WXShop.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWPerson+CoreDataProperties.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWSession.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/LastMsgInfo.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWDBUserDefaults+CoreDataProperties.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/UserInfo.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/ProfileInfoEx.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/ProfileInfoEx+CoreDataProperties.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWAtOtherInfo.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWTribeList.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWPerson.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWGroup.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/Plugins.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/WXIMSDKStringTransformer/WWPersonExtTransformer.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWOtherAtOtherInfo.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWAtInfo.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWAtMeInfo.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/LoadMsgTime.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWDBUserDefaults+CoreDataClass.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWTribeMember+CoreDataProperties.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWTribeSysList.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/WXIMSDKStringTransformer/WWPersonExtraTransformer.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWTribeMessage.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWAtMember.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWTribeList+CoreDataProperties.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/PubAccount.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/PluginMessages.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/CoreDataModel/WWTribeMember.{h,m,mm,c,cpp}",
    "WXSDK/project/ICoreData/src/WXIMSDKStringTransformer/WXIMSDKStringTransformer.{h,m,mm,c,cpp}",
    # source files for WXModule
    "WXSDK/project/WXModule/include/**/*.h",
    "WXSDK/project/WXModule/src/init/AppStatusManager.{h,m,mm,c,cpp}",
    "WXSDK/project/WXModule/src/WXServiceManager.{h,m,mm,c,cpp}",
    # source
    "WXSDK/project/tcmpushsdk/inet/inet/common/cow_container",
    "WXSDK/project/tcmpushsdk/inet/inet/common/cow_container.h",
    "WXSDK/project/tcmpushsdk/inet/inet/tcm/**/*.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/TcmsXpushOne.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/localserver/**/*.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/push/**/*.{h,m,mm,c,cpp}",
    "WXSDK/project/tcmpushsdk/inet/inet/util/**/*.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXMessengerKit/SDKWXClient/**/*.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXMessengerKit/WXClient/**/*.{h,m,mm,c,cpp}",
    "WXSDK/project/WXTribeBiz/WXTribeBiz/**/*.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/WQConnector/**/*.{h,m,mm,c,cpp}",
    "WXSDK/project/WXIMSDKFundamental/3rdParty/YWConnector/YWConnector.{h,m,mm,c,cpp}",
    # headers
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXCoreDataModel/include/**/*.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/ContactBiz/**/*.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/MultiAccountSupportBase/**/*.h",
    "WXSDK/project/Defines/**/*.h",
    "WXOpenIMSDK/WXOpenIMSDK/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOLoginModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWServerConfigurationModule/headers/**/*.h",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/headers/**/*.h",
    "WXSDK/project/WXMessengerKit/SDKExt/CoreBiz/headers/**/*.h",
    "WXSDK/project/WXMessengerKit/SDKWXClient/CoreBiz/headers/**/*.h",
    "WXSDK/project/tcmpushsdk/inet/inet/im/imcore/IMNetService.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/WXTribeBizLogic.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXConfig.h",
    "WXSDK/project/INet/ios-inet/inet/inetprotocol.h",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerTypes/WXMessengerUserDefaultKeyDef.h",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerTypes/WXClientConsts.h",
    "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerTypes/WXMessengerResponseTypes.h",
    "WXOpenIMSDK/WXOCoreModules/WXOConversationModule/WXOMessage/YWMessageBodySystemNotify+Internal.h",
    "WXSDK/project/WXMessengerKit/SDKWXClient/CoreBiz/UserInfoBiz/WXUserInfoService+WXClient.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWCacheUtil/YWCacheDef.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/WXTribeBizLogic+AtMessageReadAck.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXPerformanceMonitor/WXPerformanceMonitorDef.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogService.h",
    "WXSDK/project/tcmpushsdk/inet/inet/common/**/*.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/Headers/*.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/WXTribeUIDefine.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/headers/*.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/WXBizDB.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/TribeMsgHandler.h",
    "WXOpenIMSDK/WXOCoreModules/YWSettingModule/header/public/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/CoreDataBridge/YWCoreDataBridgeable.h",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/CoreBiz/TribeBiz/TribeBizDB.h",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/FileTranBiz/WXFileTranService.h",
    "WXSDK/project/WXMessengerKit/SDKCore/CoreBiz/FileTranBiz/InterruptedUploadHttpDataRequest.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOEHelperModule/Headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOUtilModule/public/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXORoamModule/WXORoamingServiceImpl.h",
    "WXOpenIMSDK/WXOCoreModules/WXORoamModule/IYWRoamingServiceInternal.h",
    "WXOpenIMSDK/WXOCoreModules/WXORoamModule/headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/IYWMessageTribe.h",
    "WXOpenIMSDK/WXOCoreModules/WXOUTModule/headers/public/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOPushModule/headers/protected/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOPushModule/headers/public/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOTCMSModule/headers/**/*.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOTribeModule/YWTribeMember+Internal.h",
    "WXOpenIMSDK/WXOCoreModules/WXOSecurityModule/IWXOSecurityService.h",
    "WXOpenIMSDK/WXOCoreModules/WXOLogModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/WXOExtensionModule/headers/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWHybridModule/header/**/*.h",
    "WXOpenIMSDK/WXOCoreModules/YWDBModule/YWDBMigrator.h",
    "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogDiagController.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWProfileCache/YWCache/YWCache.h",
    "WXOpenIMSDK/WXOCoreModules/WXOActionModule/Actions/YWActionHelper.h",
    "WXOpenIMSDK/WXOOptionalModules/WXOStructuredLogModule/IWXStructuredLogService.h",
    "WXOpenIMSDK/WXOCoreModules/WXOContactModule/YWBlockDelegate+DelayLoaded.h",
  ]

  s.exclude_files = [
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/OptionalBiz/CaptchaCheckBiz/WXCaptchaCheckBizLogic.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/OptionalBiz/CaptchaCheckBiz/WXCaptchaCheckResponser.{h,m,mm,c,cpp}",
    "WXSDK/project/WXMessengerKit/WXClient/Presenter/InternalBiz/ConfigBiz/WXPublicConfig/WXPublicConfig.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXUserDefaults/WWDBUserDefaults+CoreDataClass.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXUserDefaults/WWDBUserDefaults+CoreDataProperties.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLinkUrlParser/TBItemLinkParser/TBItemLinkParser.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLinkUrlParser/WXLinkUrlParser.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/WXLogDiagController.{h,m,mm,c,cpp}",
    # "WXSDK/project/WXIMSDKFundamental/2ndParty/WXLog/iConsole/iConsole.{h,mm}",
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
    # "WXSDK/project/INet/ios-inet/WXMessenger/WXMessengerError.h",
    # # Note: YWExternalImpl.m必须物理删除
    # "WXOpenIMSDK/WXOpenIMSDK/headers/public/YWExternalImpl.m",
    # "WXOpenIMSDK/WXOCoreModules/CoreDataBridge/YWFetchedResultsController.m",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWHybridConnector.{h,m,mm,c,cpp}",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWHybridEngine.{h,m,mm,c,cpp}",
    # "WXOpenIMSDK/WXOCoreModules/YWHybridModule/BridgeWebview/YWHybridWebView.{h,m,mm,c,cpp}",
  ]

  s.subspec 'no-arc' do |ss|
    ss.requires_arc = false
    ss.source_files = [
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXKeyChainUtil/WXKeyChainUtils.m",
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDWebDataDownloader.m",
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDWebDataManager.m",
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDImageView+WXSDWebCache.m",
      "WXSDK/project/WXIMSDKFundamental/2ndParty/WXSDWebData/WXSDNetworkActivityIndicator.m",
      "WXSDK/project/WXIMSDKFundamental/3rdParty/Base64/Base64.m",
      "WXSDK/project/WXIMSDKFundamental/3rdParty/JSONKit/JSONKit.m",
      "WXSDK/project/WXIMSDKFundamental/3rdParty/WXZipArchive/ZipArchive.mm",
      "WXSDK/project/WXIMSDKFundamental/3rdParty/Reachability/Reachability.m",
      "WXSDK/project/tcmpushsdk/TCMS4IOS/TCMS4IOS/include/WXNativeSecurity/SecKeyWrapper.m",
    ]
  end

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

  s.vendored_frameworks = [
    # "WXSDK/project/WXIMSDKFundamental/Frameworks/ALBBMediaService.framework",
    # "WXSDK/project/WXIMSDKFundamental/Frameworks/SecurityGuardSDK.framework",
    # "WXOpenIMSDK/Framework/YWAudioKit.framework",
    #
    # "WXSDK/project/WXIMSDKFundamental/Frameworks/WQConnector.framework",
    # "WXOpenIMSDK/Framework/YWNotification.framework",
    # "WXOpenIMSDK/Framework/YWHybridWebViewFMWK.framework",
    # "vendor_framework/WQConnector.framework",
    # "vendor_framework/YWHybridWebViewFMWK.framework",
    # "vendor_framework/YWNotification.framework",
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

  # Note: https://stackoverflow.com/questions/19481125/add-static-library-to-podspec
  # s.subspec 'OpenSSL' do |openssl|
  #   openssl.preserve_paths = "WXSDK/project/tcmpushsdk/inet/ios/openssl/include/openssl/*.h"
  #   openssl.vendored_libraries = [
  #     "WXSDK/project/tcmpushsdk/inet/ios/openssl/lib/libcrypto.a", 
  #     "WXSDK/project/tcmpushsdk/inet/ios/openssl/lib/libssl.a"
  #   ]
  #   openssl.libraries = [
  #     'ssl', 
  #     'crypto'
  #   ]
  #   openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/../../wxopenimsdk/WXSDK/project/tcmpushsdk/inet/ios/openssl/include"' }
  # end
  
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

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
