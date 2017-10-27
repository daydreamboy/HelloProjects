# Modular Framework

---

### 1. 什么是modular framework

modular framework指的是framework bundle中包含一个module.modulemap文件的framework。Xcode默认生成framework的结构，如下

```
HelloModularFramework_Default.framework
 |- Headers
 |- HelloModularFramework_Default <executable>
 |- Info.plist
 |- Modules
     |- module.modulemap
```
上面的结构，可以参考HelloModularFramework_Default工程。module.modulemap的作用是帮助编译器如何链接framework以及查找header文件。

### 2. module.modulemap文件的语法

Xcode默认生成的module.modulemap内容，如下

```
framework module HelloModularFramework_Default {
  umbrella header "HelloModularFramework_Default.h"

  export *
  module * { export * }
}
```

针对上面的内容，解释如下

* umbrella header文件    
和framework名字同名的header文件，它用于import其他public header文件，这样使用framework的用户直接#import <framework/framework.h>，而不用关心#import具体哪个文件

* module \*
定义


### 3. modular framework vs. none-modular framework

| modular framework | none-modular framework |
|-------------------|------------------------|
| 可以使用@import \<framework\>;导入头文件 | 不能使用@import \<framework\>;导入头文件，编译报错"Module 'XXX' not found" |


### 2. 相关Xcode配置Tips

#### （1）如何修改Product输出的位置

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Targets</b>选择对应的target，<b>Build Settings</b>中找到或者搜索<b>Per-configuration Build Products Path</b>，修改到指定位置。例如，`$(PROJECT_DIR)/Frameworks`，这里Frameworks文件夹需要提前创建好，否则Xcode不会自动创建。

#### （2）如何编译none-modular framework
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择framework对应的target，<b>Build Settings</b>中找到或者搜索<b>Defines Module</b>（`DEFINES_MODULE`），将默认YES换成NO，这样编译出来的framework没有包含Modules文件夹

