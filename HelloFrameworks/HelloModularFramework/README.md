# Modular Framework

[TOC]

## 1、什么是modular framework

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;modular framework指的是framework bundle中包含一个modulemap文件的framework。Xcode默认生成framework的结构，如下

```
HelloModularFramework_Default.framework
 |- Headers
 |- HelloModularFramework_Default <executable>
 |- Info.plist
 |- Modules
     |- module.modulemap
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;modulemap文件的作用是帮助编译器如何链接framework以及查找header文件，但是modulemap文件不能控制哪些头文件放在Headers文件夹中。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;modular framework除了支持按照传统方式`#import <framework/framework.h>`，还支持更简洁的方式`@import module;`，同时也支持submodule，即`@import module.submodule;`。



## 2、自定义modulemap文件

Xcode默认生成的module.modulemap文件的内容，如下

```
framework module HelloModularFramework_Default {
  umbrella header "HelloModularFramework_Default.h"

  export *
  module * { export * }
}
```

针对上面的内容，通过手动写modulemap文件来详细解释。先介绍如何设置自己的modulemap文件。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择framework对应的target，<b>Build Settings</b>中找到或者搜索<b>Module Map File</b>，指定自定义的modulemap文件。建议使用`${PROJECT_DIR}`或者`${SRCROOT}`来指定modulemap文件的位置。
>
注意：modulemap文件不能命名为module.modulemap，见后面redefinition of module 'XXX'的问题。



### （1）声明头文件

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在上面的framework结构中，可以知道所有公开的头文件都在Headers文件夹中，但是如何向外部声明这些头文件，则需要一定规则，而modulemap文件描述这些规则。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下面介绍几种声明头文件的方式。

#### a. header "xxx.h"

```
framework module HelloModularFramework_Header {
    header "PublicClassA.h"
    header "PublicClassB.h"
    // ...
}
```

对于需要公开的头文件，可以全部用header "xxx.h"声明出来。

#### b. umbrella header "xxx.h"

modulemap文件

```
framework module HelloModularFramework_UmbrellaHeader {
    umbrella header "HelloModularFramework_UmbrellaHeader.h"
}
```

HelloModularFramework_UmbrellaHeader.h

```
#import <HelloModularFramework_UmbrellaHeader/PublicClassA.h>
#import <HelloModularFramework_UmbrellaHeader/PublicClassB.h>
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;和framework同名的头文件是umbrella头文件，在modulemap文件中，使用umbrella header声明一个umbrella头文件，在umbrella头文件中添加外部需要的头文件，这样不必使用header方式修改modulemap文件。

> 注意：这里PublicClassA.h和PublicClassB.h可能还引入其他头文件。例如PublicClassC.h被PublicClassB.h引入，这时PublicClassC.h也是被公开的。


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果有PublicClassD头文件，也放在Headers文件夹中，但是没有引入在umbrella头文件中，则这个PublicClassD是不能使用的，即使外部可以直接#import它，但是会找不到类。
>
unknown receiver 'PublicClassD'; did you mean 'PublicClassA'

如果不想把PublicClassD.h引入在umbrella头文件中，可以单独声明这个头文件 （umbrella header和header可以一起使用），如下

```
framework module XXX {
    umbrella header "XXX.h"
    // 如果PublicClassD.h没有引入在umbrella头文件，可以单独header声明
    header "PublicClassD.h"
}
```



### （2）定义module和submodule

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;module用于定义一组公开的头文件声明，例如下面的HelloModularFramework_Header就是一个module。

```
framework module HelloModularFramework_Header {
    header "PublicClassA.h"
    header "PublicClassB.h"
    // ...
}
```

如果要定义submodule，使用module关键字嵌套定义就可以了。例如

```
framework module HelloModularFramework_Submodule {
    module PublicClassA {
        header "PublicClassA.h"
        export PublicClassD
    }
    
    explicit module PublicClassB {
        header "PublicClassB.h"
    }
    
    module PublicClassC {
        // PublicClassC.h also import PublicClassB.h
        header "PublicClassC.h"
    }
    
    explicit module PublicClassD {
        header "PublicClassD.h"
    }
    
    export PublicClassD
}
```

上面定义了4个submodule：PublicClassA、PublicClassB、PublicClassC和PublicClassD

* PublicClassA.h，可以通过@import HelloModularFramework\_Submodule或者@import HelloModularFramework\_Submodule.PublicClassA来访问头文件

* PublicClassB.h，由于使用explicit关键词修饰了PublicClassB，所以只能通过@import HelloModularFramework\_Submodule.PublicClassB来访问头文件。
> 值得注意的是，在PublicClassC.h引入了PublicClassB.h。如果@import HelloModularFramework\_Submodule.PublicClassC是访问不了PublicClassB.h，但是使用#import \<HelloModularFramework\_Submodule/PublicClassC.h\>则可以访问PublicClassB.h

* PublicClassC.h，可以通过@import HelloModularFramework\_Submodule或者@import HelloModularFramework\_Submodule.PublicClassC来访问头文件

* PublicClassD.h，虽然module PublicClassD被explicit修饰，但是它在module HelloModularFramework_Submodule和module PublicClassA都使用export导入了，所以可以通过@import HelloModularFramework\_Submodule或者@import HelloModularFramework\_Submodule.PublicClassA或者HelloModularFramework\_Submodule.PublicClassD来访问。



### （3）定义inferred submodule

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;modulemap语法还支持自动推断的submodule，即inferred submodule，从umbrella header中自动推断出所有的submodule。例如


HelloModularFramework_InferredSubmodule.h

```
#import <HelloModularFramework_InferredSubmodule/PublicClassA.h>
#import <HelloModularFramework_InferredSubmodule/PublicClassB.h>
```

PublicClassB.h

```
#import "PublicClassC.h"
...
```

modulemap文件

```
framework module HelloModularFramework_InferredSubmodule {
    umbrella header "HelloModularFramework_InferredSubmodule.h"
    
    // Note: module * must require a umbrella header
    module * {
    }
}
```

上面使用module *定义umbrella头文件中所有引入到的头文件（包括间接引入，例如PublicClassC.h）作为submodule。这样可以直接使用@ HelloModularFramework_InferredSubmodule.<头文件名>;声明头文件，例如

```
@import HelloModularFramework_InferredSubmodule.PublicClassA;
@import HelloModularFramework_InferredSubmodule.PublicClassB;
@import HelloModularFramework_InferredSubmodule.PublicClassC;
```



## 3、export的用法

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在上面的inferred submodule例子中，存在一个小问题，就是submodule没有相互引用，即@import HelloModularFramework_InferredSubmodule.PublicClassA;只能访问PublicClassA类，而不能访问PublicClassB。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;export关键字，用于向submodule导入其他的submodule。之前有个例子使用`export PublicClassD`，用于导入submodule。但是`export *`并不是指导入所有submodule，而是自动推断submodule包含的成员。例如

Derived.h

```
#import "Base.h"
...
```

modulemap文件

```
framework module HelloModularFramework_Export {
    
    module Base {
        header "Base.h"
    }
    
    module Derived {
        header "Derived.h"
        // when Derived.h includes Base.h, so use export * instead of export Base
        export *
    }

    module PublicClassA {
        header "PublicClassA.h"
    }
}
```

上面Derived.h包含Base.h，使用export *自动推断Derived.h引入的所有头文件，这样@import HelloModularFramework_Export.Derived;可以同时使用Derived类和Base类。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;另外，inferred module中也可以使用export *来自动推断submodule包括哪些其他的submodule。将上面的modulemap重新使用inferred module方式写一遍，如下

HelloModularFramework_InferredSubmoduleWithExport.h

```
#import <HelloModularFramework_InferredSubmoduleWithExport/Base.h>
#import <HelloModularFramework_InferredSubmoduleWithExport/Derived.h>
#import <HelloModularFramework_InferredSubmoduleWithExport/PublicClassA.h>
```

modulemap文件

```
framework module HelloModularFramework_InferredSubmoduleWithExport {
    umbrella header "HelloModularFramework_InferredSubmoduleWithExport.h"
    
    module * {
        export *
    }
}
```

上面在每个inferred submodule都使用export *导入引入到的头文件，这样@import HelloModularFramework_Export.Derived;还是可以同时使用Derived类和Base类，但没有使用PublicClassA.h，因为PublicClassA.h没有在Derived.h中引入。



## 4、modular framework vs. none-modular framework

| modular framework | none-modular framework |
|-------------------|------------------------|
| 可以使用@import \<framework\>;导入头文件 | 不能使用@import \<framework\>;导入头文件，编译报错"Module 'XXX' not found" |



## 5、几个工程说明

* HelloModularFramework_DefaultModuleMap    
用于展示Xcode默认生成modulemap文件

* HelloModularFramework_CustomizedModuleMap    
用于展示如何设置自定义的modulemap文件

* HelloModularFramework_NoneModuleMap    
用于展示如何定义none modular framework，即framework没有modulemap文件

* HelloModularFramework_Header    
展示header语法

* HelloModularFramework_UmbrellaHeader    
展示umbrella header语法

* HelloModularFramework_Submodule    
展示如何定义submodule

* HelloModularFramework_InferredSubmodule    
展示如何使用module *定义inferred submodule

* HelloModularFramework_Export    
展示如何使用export *

* HelloModularFramework_InferredSubmoduleWithExport    
展示submodule \*结合export \*



## 6、相关Xcode配置Tips

### （1）如何修改Product输出的位置

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Targets</b>选择对应的target，<b>Build Settings</b>中找到或者搜索<b>Per-configuration Build Products Path</b>，修改到指定位置。例如，`$(PROJECT_DIR)/Frameworks`，这里Frameworks文件夹需要提前创建好，否则Xcode不会自动创建。



### （2）如何编译none-modular framework

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择framework对应的target，<b>Build Settings</b>中找到或者搜索<b>Defines Module</b>（`DEFINES_MODULE`），将默认YES换成NO，这样编译出来的framework没有包含Modules文件夹



### （3）解决redefinition of module 'XXX'

>
.../module.modulemap:1:8: error: redefinition of module 'XXX'
module XXX {    
.../module.modulemap:1:8: note: previously defined here
module XXX {

原因是自定义的modulemap文件不能是`module.modulemap`，应该是Xcode的bug[^1]，可以将`module.modulemap`命名成\<framework\>.modulemap或者其他文件名



### （4）解决Could not build module 'XXX'

>
error: include of non-modular header inside framework module 'HelloModularFramework_InferredSubmodule': '.../PublicClassA.h'
>
warning: umbrella header for module 'HelloModularFramework_InferredSubmodule' does not include header 'PublicClassA.h'

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;原因是当前链接framework的工程，没有把framework加入到Embedded Binaries中。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;将需要添加framework或者包含它的文件夹，拖拽到工程中，<b>Add to targets</b>不要勾选任何target。选择需要添加framework的target，<b>General</b>中找到<b>Embedded Binaries</b>，将点击+，找到刚才拖拽的framework或者文件夹，选择Add，这时<b>Linked Frameworks and Libraries</b>也自动添加上framework。



## References

[^1]: http://www.openradar.me/30194818
[^2]: http://blog.bjhomer.com/2015/05/defining-modules-for-custom-libraries.html

