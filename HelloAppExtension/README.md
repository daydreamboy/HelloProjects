# HelloAppExtension

[TOC]

## 1、介绍App Extension

App extension是app提供的功能，用于和系统或者其他app进行交互。常见的app extension是Home screen上的widget。



官方描述如下[^1]

> App extensions let you extend custom functionality and content beyond your app and make it available to users while they’re interacting with other apps or the system. For example, your app can appear as a widget on the Home screen, add new buttons in the Action sheet, offer photo filters within the Photos app, or automatically upgrade user’s accounts to use strong passwords or Sign in with Apple. Use extensions to place the power of your app wherever your users need it most.



### （1）App Extension的类型

根据扩展点进行分类[^1]，如下

| Extension Point                                              | Description                                                  | iOS/iPadOS | macOS | tvOS | watchOS |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :--------: | :---: | :--: | :-----: |
| [Action](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Action.html#//apple_ref/doc/uid/TP40014214-CH13-SW1) | Add custom actions to the share sheet to invoke your app’s functionality from any app. |     ●      |   ●   |      |         |
| [Audio Unit](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/AudioUnit.html#//apple_ref/doc/uid/TP40014214-CH22-SW1) | Create and modify audio in any app that uses sound, including music production apps such as GarageBand or Logic Pro X. |     ●      |   ●   |      |         |
| [Authentication Services](https://developer.apple.com/videos/play/tech-talks/301/) | Streamline authentication for users by enabling single sign-on. |     ●      |   ●   |      |         |
| [Account Authentication Modification](https://developer.apple.com/documentation/authenticationservices/upgrading_account_security_with_an_account_authentication_modification_extension) | Automatically upgrade user passwords to strong passwords, or convert accounts to use Sign in with Apple. |     ●      |       |      |         |
| [AutoFill Credential Provider](https://developer.apple.com/videos/play/wwdc2018/204/) | Surface credentials from your app in Password Autofill and pull your app’s password data into the Password AutoFill workflow. |     ●      |   ●   |      |         |
| [Broadcast Setup UI / Broadcast UI](https://developer.apple.com/videos/play/wwdc2018/601/) | Capture the contents of a user’s screen to stream to a video broadcast service. |     ●      |   ●   |  ●   |         |
| [Call Directory](https://developer.apple.com/documentation/callkit) | Display caller identification from your appʼs custom contact list so users know who’s calling. |     ●      |       |      |         |
| [ClassKit Content Provider](https://developer.apple.com/documentation/classkit/clscontextprovider) | Update the status of your appʼs activities so that status is visible in the Schoolwork app. |     ●      |   ●   |      |         |
| [Content Blocker](https://developer.apple.com/documentation/safariservices/creating_a_content_blocker) | Provide rules for hiding elements, blocking loads, and stripping cookies from Safari requests. |     ●      |   ●   |      |         |
| [Custom Keyboard](https://developer.apple.com/documentation/uikit/keyboards_and_input/creating_a_custom_keyboard) | Provide systemwide customized text input for unique input methods or specific languages. |     ●      |       |      |         |
| [File Provider](https://developer.apple.com/documentation/fileprovider) | Let other apps access the documents and directories stored and managed by your app. |     ●      |       |      |         |
| [File Provider UI](https://developer.apple.com/documentation/fileproviderui) | Add custom actions to the document browserʼs context menu for documents that your app manages. |     ●      |       |      |         |
| [Finder Sync](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Finder.html#//apple_ref/doc/uid/TP40014214-CH15-SW1) | Keep files in sync with a back-end storage service.          |            |   ●   |      |         |
| [iMessage](https://developer.apple.com/documentation/messages) | Allow users to send text, stickers, media files, and interactive messages. |     ●      |       |      |         |
| [Intents](https://developer.apple.com/documentation/sirikit/creating_an_intents_app_extension) | Let users interact with your app using Siri.                 |     ●      |   ●   |  ●   |    ●    |
| [Intents UI](https://developer.apple.com/documentation/sirikit/creating_an_intents_ui_extension) | Customize the interface for interactions with your app in Siri conversations or Maps. |     ●      |       |      |         |
| [Message Filter](https://developer.apple.com/documentation/sms_and_call_reporting/sms_and_mms_message_filtering) | Identify and filter unwanted SMS and MMS messages.           |     ●      |       |      |         |
| [Network](https://developer.apple.com/videos/play/wwdc2019/714) | Provide system-level networking services such as VPN, proxies, or content filtering. |     ●      |   ●   |      |         |
| [Notification Center](https://developer.apple.com/documentation/usernotificationsui/customizing_the_appearance_of_notifications) | Customize the appearance of your app’s notification alerts.  |     ●      |       |      |         |
| [Notification Service](https://developer.apple.com/documentation/usernotifications/modifying_content_in_newly_delivered_notifications) | Modify the payload of a remote notification before it’s displayed on the user’s device. |     ●      |   ●   |      |    ●    |
| [Persistent Token](https://developer.apple.com/documentation/cryptotokenkit/authenticating_users_with_a_cryptographic_token) | Grant access to user accounts and the keychain using a token. |     ●      |   ●   |      |         |
| [Photo Editing](https://developer.apple.com/documentation/photokit/creating_photo_editing_extensions) | Allow your app to edit assets directly within the Photos app. |     ●      |   ●   |      |         |
| [Photo Project](https://developer.apple.com/documentation/photokit/creating_a_slideshow_project_extension_for_photos) | Augment the macOS Photos app with extensions that support project creation. |            |   ●   |      |         |
| [Quick Look Preview](https://developer.apple.com/videos/play/wwdc2018/237/) | Provide previews of documents your app owns so they can be viewed in any app. |     ●      |   ●   |      |         |
| [Safari Services](https://developer.apple.com/documentation/safariservices) | Extend the web-browsing experience in Safari by leveraging web technologies and native code |            |   ●   |      |         |
| [Share](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html#//apple_ref/doc/uid/TP40014214-CH12-SW1) | Let users post to your social-network service from any app.  |     ●      |   ●   |      |         |
| [Smart Card Token](https://developer.apple.com/documentation/cryptotokenkit/authenticating_users_with_a_cryptographic_token) | Grant access to user accounts and the keychain using a hardware-based token. |            |   ●   |      |         |
| [Spotlight Index](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/AppContent.html#//apple_ref/doc/uid/TP40016308-CH7-SW1) | Make content in your app searchable in Spotlight, Safari, Siri, and more. |     ●      |   ●   |      |         |
| [Sticker Pack](https://developer.apple.com/documentation/messages) | Add custom stickers to Messages.                             |     ●      |       |      |         |
| [Thumbnail](https://developer.apple.com/documentation/quicklookthumbnailing/providing_thumbnails_of_your_custom_file_types) | Display thumbnails of your custom document types in all apps. |     ●      |   ●   |      |         |
| [TV Top Shelf](https://developer.apple.com/documentation/tvservices) | Help users discover your app by providing Top Shelf content and a description of your tvOS app. |            |       |  ●   |         |
| [Unwanted Communication](https://developer.apple.com/documentation/sms_and_call_reporting/sms_and_call_spam_reporting) | Block incoming phone calls using your app’s custom unsolicited caller database. |     ●      |       |      |         |
| [Widget](https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension) | Show relevant, glanceable content from your app on the iOS Home screen or macOS Notification Center. |     ●      |   ●   |      |         |
| [Xcode Source Editor](https://developer.apple.com/documentation/xcodekit/creating_a_source_editor_extension) | Provide custom editing features directly inside Xcode’s source editor. |            |   ●   |      |         |



### （2）关于App Extension的官方文档

编程文档：[App Extension Programming Guide](https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/index.html)

HIG规范描述：https://developer.apple.com/design/human-interface-guidelines/ios/extensions



### （3）常用App Extension

#### a. Sharing and Actions[^2]

分享 (Sharing)和操作 (Action)是系统Share Sheet提供的功能，常见于Safari的分享按钮唤起的界面，如下

<img src="https://developer.apple.com/design/human-interface-guidelines/ios/images/sharing-action_2x.png" alt="Sharing and Actions" style="zoom:50%;" />

值得说明的是

* Action的图标大小是70px X 70px



## 2、Unavailable API for App extensions

​       由于App Extension仅完成特定的功能，官方文档[^3]描述App Extension不能使用用宏`NS_EXTENSION_UNAVAILABLE_IOS`标记的API。

举个例子，不能使用UIApplication的sharedApplication属性

```objective-c
@property(class, nonatomic, readonly) UIApplication *sharedApplication NS_EXTENSION_UNAVAILABLE_IOS("Use view controller based solutions where appropriate instead.");
```

如果使用sharedApplication属性，编译App Extension，则会报错。



系统提供下面的宏，用于标记哪些API不能用于App Extension

```c
#define NS_EXTENSION_UNAVAILABLE(_msg)      __OS_EXTENSION_UNAVAILABLE(_msg)
#define NS_EXTENSION_UNAVAILABLE_MAC(_msg)  __OSX_EXTENSION_UNAVAILABLE(_msg)
#define NS_EXTENSION_UNAVAILABLE_IOS(_msg)  __IOS_EXTENSION_UNAVAILABLE(_msg)
```



## 3、CocoaPods支持App Extension[^4]

CocoaPods 1.1.0开始在pod xcconfig添加APPLICATION_EXTENSION_API_ONLY属性，如下

```properties
APPLICATION_EXTENSION_API_ONLY = YES
```

但是该属性对于同时支持App和App Extension的Pod并不适用，因为不能单独编译App Extension或App。



### （1）App和App Extension采用subspec方式

这篇文章[^4]采用App和App Extension区分代码的方式，将仅支持App Extension的代码采用subspec方式。

举个例子，如下

podspec文件，如下

```ruby
Pod::Spec.new do |s|
  s.name             = "MyLibrary"
  # Omitting metadata stuff and deployment targets
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'MyLibrary/*.{m,h}'
  end

  s.subspec 'AppExtension' do |ext|
    ext.source_files = 'MyLibrary/*.{m,h}'
    # For app extensions, disabling code paths using unavailable API
    ext.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MYLIBRARY_APP_EXTENSIONS=1' }
  end
end
```

Podfile文件，如下

```ruby
abstract_target 'App' do
  # Shared pods between App and extension, compiled with same preprocessor macros
  pod 'AFNetworking'

  target 'MyApp' do
    pod 'MyLibrary/Core'
  end

  target 'MyExtension' do
    pod 'MyLibrary/AppExtension'
  end
end
```



### （2）采用运行时方式

对于需要同时支持App和App Extension的代码，不能采用subspec方式，可以采用运行时方式。

举个例子，如下

```objective-c
+ (nullable UIApplication *)getSharedApplication {
#if COCOAPODS
//#error "compile by cocoapods"
    id object = nil;
    if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
        object = [UIApplication performSelector:@selector(sharedApplication)];
    }
    return object;
#else
//#error "compile not by cocoapods"
    return UIApplication.sharedApplication;
#endif
}
```

* 如果该代码采用源码集成到App和App Extension，则COCOAPODS宏生效，走运行时方式，保证App能获取sharedApplication对象。
* 如果该代码采用二进制集成，则COCOAPODS不生效，直接使用sharedApplication属性







## References

[^1]:https://developer.apple.com/app-extensions/
[^2]:https://developer.apple.com/design/human-interface-guidelines/ios/extensions/sharing-and-actions/
[^3]:https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionOverview.html#//apple_ref/doc/uid/TP40014214-CH2-SW2
[^4]:https://miqu.me/blog/2016/11/28/app-extensions-xcode-and-cocoapods-omg/

