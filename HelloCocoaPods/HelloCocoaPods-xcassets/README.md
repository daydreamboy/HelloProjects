# HelloXCAssets
--

## 1. xcasset文件夹


xcasset文件夹会被Xcode编译成Assets.car文件，Assets.car文件有4种存放方式：

```
xxx.app
 |- Assets.car (1)
 |- Frameworks
 |   |- HelloXCAssets.framework
 |       |- Assets.car (3)
 |       |- MyXCAssets.bundle
 |           |- Assets.car (4)
 |- main.bundle
     |- Assets.car (2)
```

* 读取Assets.car文件，依赖Info.plist文件[^1] [^2]

* HelloXCAssets-Issues中，s.resource_bundles名称和framework同名，这样对应的Info.plist文件会冲突

* 读取中s.resource_bundles或者s.resource的xcassets image [^3]


References
--
[^1]: http://www.openradar.me/24056523
[^2]: https://github.com/CocoaPods/CocoaPods/issues/4897
[^3]: https://stackoverflow.com/questions/32577227/how-to-use-images-asset-catalog-in-cocoapod-library-for-ios

https://stackoverflow.com/questions/33063233/cant-load-images-from-xcasset-in-cocoapods