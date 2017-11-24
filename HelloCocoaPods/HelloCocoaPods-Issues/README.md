# CocoaPods Issues
--

TOC

## 1. 文件名冲突

文件组织结构，如下

```
<Pod Name>
 |- Assets
 |- Classes
     |- ReplaceMe.m
     |- A
     |  |- ReplaceMe.m
     |
     |- B
        |- ReplaceMe.m 
```

问题1： pod install产生警告：[!] [Xcodeproj] Generated duplicate UUIDs

![](images/Generated duplicated UUIDs.png)

问题2：有可能少编译的源文件

podspec文件

```
s.source_files = 'FileNameConflict/Classes/**/*'
```

![](images/FileNameConfilct.png)

上面B中的ReplaceMe.m重复链接两次，而A中ReplaceMe.m没有编译进来。



