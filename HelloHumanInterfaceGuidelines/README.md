# 学习Human Interface Guidelines(HIG)

[TOC]

## 1、关于HIG[^1]

​        Human Interface Guidelines是Apple针对它推出的设备和系统而设计的一套UI规范。值得了解这些规范，方便开发者更加贴近Apple风格。



## 2、Dark Mode[^2]

iOS 13推出Dark Mode，在设置 > 显示与亮度 > 外观，可以选择浅色和深色两种模式。

适配Dark Mode的主要工作在于颜色的适配，NSHipster这篇[文章](https://nshipster.com/dark-mode/)，较好描述如何适配颜色。下面总结一些重要的内容，如下



### （1）不使用颜色字面常量



Objective-C版本

```shell
$ find . -name '*.swift'  \
    -exec sed -i '' -E 's/#colorLiteral\(red: (.*), green: (.*), blue: (.*), alpha: (.*)\)/UIColor(red: \1, green: \2, blue: \3, alpha: \4)/' {} \;
```



Swift版本

```shell
$ find . -name '*.swift'  \
    -exec sed -i '' -E 's/#colorLiteral\(red: (.*), green: (.*), blue: (.*), alpha: (.*)\)/UIColor(red: \1, green: \2, blue: \3, alpha: \4)/' {} \;
```



### （2）使用system color



### （3）使用semantic color



### （4）使用dynamic color







## References

[^1]:https://developer.apple.com/design/human-interface-guidelines/
[^2]:https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode/



