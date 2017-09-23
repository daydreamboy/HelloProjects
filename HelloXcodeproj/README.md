## xcodeproj Tutorial

### 1. 学习材料

* GitHub Home, [https://github.com/CocoaPods/Xcodeproj](https://github.com/CocoaPods/Xcodeproj)
* gem documentation, [http://www.rubydoc.info/gems/xcodeproj](http://www.rubydoc.info/gems/xcodeproj)
* Dash安装xcodeproj文档
![xcodeproj for Dash](images/xcodeproj for Dash.png)

### 2. 安装xcodeproj

```
$ gem install xcodeproj
```

### 3. 基本概念

Xcodeproj模块的类结构图，如下

```
Xcodeproj
	Command < Command
	Config < Object
	Constants
	Differ
	Helper
	Informative < PlainInformative
	PlainInformative < StandardError
	Plist
	Project < Object
	UserInterface
	Workspace < Object
	XCScheme < Object
	XcodebuildHelper < Object
```

* xcodeproj是ruby写的gem，gem类似包的概念。
* `Xcodeproj`是Module，它包含的很多类（e.g. `Project`）是对应Xcode工程的配置文件（project.pbxproj等）。对这些Class对象进行配置，然后保存，达到修改Xcode工程的配置文件的目的。
* 一个.xcodeproj文件，实际是一个文件夹，类似bundle。如下

```
XXX.xcodeproj
	project.pbxproj
	project.xcworkspace
	xcuserdata
```

* project.pbxproj是一个plist文件，root对象是NSDictionary，可以用PlistEdit Pro打开。根据.pbxproj的结构，对照`Project`的[方法列表](http://www.rubydoc.info/gems/xcodeproj/Xcodeproj/Project)基本可以了解如何用脚本配置Xcode。

![Method List](images/Method List.png)

Note: #method是实例方法，method是类方法
