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







## References

[^1]:https://developer.apple.com/app-extensions/

