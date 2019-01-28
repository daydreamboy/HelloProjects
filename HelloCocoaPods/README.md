# HelloCocoaPods
[TOC]

## 1、CocoaPods集成原理

### (1) Pod的管理

CocoaPods是一组rubygem，核心的有CocoaPods/CococaPod、CocoaPods/Core、CocoaPods/Xcodeproj

* CocoaPods/CococaPod，属于接口层，用于和用户交互，提供pod命令
* CocoaPods/Core，处理Podfile和podspec
* CocoaPods/Xcodeproj，支持对.xcodeproj和.xcworkspace文件的读写

如果需要观察pod install的详细过程，加上`--verbose`选项

Podfile是Pod使用方可以定制的；而podspec是Pod提供方可以定制的

podspec都缓存在./cocoapods文件夹下，podspec文件描述源码或者二进制文件的位置（remote或者local），一般是指向远端的git仓库的一个commit SHA（branch、tag最终会确定成commit SHA）。读取podspec将源码或者二进制文件缓存在~/Library/Caches/CocoaPods.



### (2) Pod的编译

* user_target，集成的主target，一般是.app，可以是.framework
* aggregate\_target，挂在user\_target上的一个静态库，源码只有一个dummy文件，主要用于触发它所依赖的所有pod_target去编译以及执行脚本（安装framework、resource_bundle等脚本）
* pod_target，Pod库对应的target



## 2、podspec语法

老版本的[podspec手册](https://guides.cocoapods.org/syntax/podspec.html)中，有s.xcconfig属性，现在换成s.user\_target\_xcconfig和s.pod\_target\_xcconfig

* s.user\_target\_xcconfig，用于设置user\_target和aggregate\_target
* s.pod\_target\_xcconfig，用于设置pod\_target
* s.xcconfig，相当于同时设置s.user\_target\_xcconfig和s.pod\_target\_xcconfig

> 注意：s.xcconfig设置的属性不能和s.user\_target\_xcconfig、s.pod\_target\_xcconfig重复，否则属性会重复两遍在user\_target或者pod\_target中



## 3、pod install vs. pod update[^1]

​       pod使用Podfile和Podfile.lock对pod进行版本管理，确保这个两个文件都在版本控制中（under version control）。官方给出pod install和pod update的区别，这里归纳如下

| pod install                                                | pod update                                |
| :--------------------------------------------------------- | ----------------------------------------- |
| 对pod增加、删除使用pod install                             | 对单个或者全部pod进行更新，使用pod update |
| 新手接触工程（有Podfile和Podfile.lock），使用pod install   | /                                         |
| 初始化工程（有Podfile，没有Podfile.lock），使用pod install | /                                         |



## 4、Pods文件是否需要版本控制[^2]

官方给出的回答是取决于使用者，即可以加入版本控制，也可以不使用版本控制。

> Whether or not you check in your `Pods` folder is up to you, as workflows vary from project to project. 



官方也给出两种方式的好处，如下

| checking in the Pods directory                               | ignoring the Pods directory                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| clone之后，工程可以立即运行。不需要pod install以及网络连接（⭑） | 仓库占较少的磁盘空间（⭑）                                    |
| Pods下面的代码和库总是可用的，即使其中一个pod的下载链接挂掉了 | 只要pod可以下载，Pods文件夹都创建一模一样的                  |
| clone之后，Pods文件夹和原始安装后Pods文件夹是一模一样的      | Pods文件夹下面没有版本冲突和合并，例如不同pod版本的冲突（⭑） |

说明

> ⭑标记的是个人实践过程，觉得比较明显的好处。





## References

[^1]:https://guides.cocoapods.org/using/pod-install-vs-update.html
[^2]:https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control



