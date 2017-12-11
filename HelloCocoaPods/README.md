# HelloCocoaPods
--

TOC

## 1. CocoaPods集成原理

CocoaPods是一组rubygem，核心的有CocoaPods/CococaPod、CocoaPods/Core、CocoaPods/Xcodeproj

* CocoaPods/CococaPod，属于接口层，用于和用户交互，提供pod命令
* CocoaPods/Core，处理Podfile和podspec
* CocoaPods/Xcodeproj，支持对.xcodeproj和.xcworkspace文件的读写

如果需要观察pod install的详细过程，加上--verbose选项

Podfile，是Pod使用方可以定制的；而podspec，是Pod提供方可以定制的

podspec都缓存在./cocoapods文件夹下，podspec文件描述源码或者二进制文件的位置（remote或者local），一般是指向远端的git仓库的一个commit SHA（branch、tag最终会确定成commit SHA）。读取podspec将源码或者二进制文件缓存在~/Library/Caches/CocoaPods

