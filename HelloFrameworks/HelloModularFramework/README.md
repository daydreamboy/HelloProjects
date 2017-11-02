# Modular Framework

---

### 1. 什么是modular framework

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

### 2. 自定义modulemap文件

Xcode默认生成的module.modulemap文件的内容，如下

```
framework module HelloModularFramework_Default {
  umbrella header "HelloModularFramework_Default.h"

  export *
  module * { export * }
}
```

针对上面的内容，后面会详细解释。先介绍如何设置自己的modulemap文件。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择framework对应的target，<b>Build Settings</b>中找到或者搜索<b>Module Map File</b>，指定自定义的modulemap文件。建议使用${PROJECT_DIR}或者${SRCROOT}来指定modulemap文件的位置。
>
注意：modulemap文件不能命名为module.modulemap，见后面redefinition of module 'XXX'的问题。

### 4. 声明头文件

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在上面的framework结构中，可以知道所有公开的头文件都在Headers文件夹中，但是如何向外部声明这些头文件，则需要一定规则，而modulemap文件描述这些规则。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下面介绍几种声明头文件的方式。

#### （1）header "xxx.h"

```
framework module HelloModularFramework_Header {
    header "PublicClassA.h"
    header "PublicClassB.h"
    // ...
}
```

对于需要公开的头文件，可以全部用header "xxx.h"声明出来。

#### （2）umbrella header "XXX.h"

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

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;和framework同名的头文件是umbrella头文件，在modulemap文件中，使用umbrella header声明一个umbrella头文件，在umbrella头文件中添加外部需要的头文件，这样不必使用方式(1)修改modulem文件。

> 注意：这里PublicClassA.h和PublicClassB.h可能还引入其他头文件。例如PublicClassC.h被PublicClassB.h引入，这时PublicClassC.h也是被公开的。


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果有PublicClassD头文件，也放在Headers文件夹中，但是没有引入在umbrella头文件中，则这个PublicClassD是不能使用的，即使外部可以直接#import它，但是会找不到类。
>
unknown receiver 'PublicClassD'; did you mean 'PublicClassA'

如果不想把PublicClassD.h引入在umbrella头文件中，可以单独声明这个头文件 （umbrella header和header可以一起使用），如下

```
framework module XXX {
    umbrella header "XXX.h"
    // 如果PublicClassD.h没有引入在umbrella头文件，可以单独header声明
    header "PublicClassB.h"
}
```

### 5. 定义module和submodule

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

上面定义了三个submodule：PublicClassA、PublicClassB、PublicClassC和PublicClassD

* PublicClassA.h，可以通过@import HelloModularFramework\_Submodule或者@import HelloModularFramework\_Submodule.PublicClassA来访问头文件

* PublicClassB.h，由于使用explicit关键词修饰了PublicClassB，所以只能通过@import HelloModularFramework\_Submodule.PublicClassB来访问头文件。
> 值得注意的是，在PublicClassC.h引入了PublicClassB.h。如果@import HelloModularFramework\_Submodule.PublicClassC是访问不了PublicClassB.h，但是使用#import \<HelloModularFramework\_Submodule/PublicClassC.h\>则可以访问PublicClassB.h

* PublicClassC.h，可以通过@import HelloModularFramework\_Submodule或者@import HelloModularFramework\_Submodule.PublicClassC来访问头文件

* PublicClassD.h，虽然module PublicClassD被explicit修饰，但是它在module HelloModularFramework_Submodule和module PublicClassA都使用export导入了，所以可以通过@import HelloModularFramework\_Submodule或者@import HelloModularFramework\_Submodule.PublicClassA或者HelloModularFramework\_Submodule.PublicClassD来访问。


TODO
----


上面在HelloModularFramework_Submodule中定了两个submodule：A和B。A可以通过导入parent module访问得到，而B由于使用了`explicit`关键字，所以必须显示导入submodule B才访问它所拥有的头文件。

```
framework module HelloModularFramework_Export {
    
    explicit module A {
        header "PublicClassA.h"
        export B
        // or
        // export *
    }
    
    explicit module B {
        header "PublicClassB.h"
    }
}
```

和explicit关键字作用有点相反的是export关键字，它可以将其他module导入自己的module中。例如上面A导入了B，所以使用下面几种方式访问B。

>
@import HelloModularFramework\_Export.A;   
@import HelloModularFramework\_Export.B;

除了export导入特定module，也使用`export *`导入其他任意module。例如，如果所有submodule都声明为explicit，则可以使用export *





工程见HelloModularFramework_Submodule。



### 4. modular framework vs. none-modular framework

| modular framework | none-modular framework |
|-------------------|------------------------|
| 可以使用@import \<framework\>;导入头文件 | 不能使用@import \<framework\>;导入头文件，编译报错"Module 'XXX' not found" |


### 5. 几个工程说明

* HelloModularFramework_DefaultModuleMap    
用于展示Xcode默认生成modulemap文件

* HelloModularFramework_CustomizedModuleMap    
用于展示如何设置自定义的modulemap文件

* HelloModularFramework_NoneModuleMap    
用于展示如何定义none modular framework，即framework没有modulemap文件

* 

### 2. 相关Xcode配置Tips

#### （1）如何修改Product输出的位置

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Targets</b>选择对应的target，<b>Build Settings</b>中找到或者搜索<b>Per-configuration Build Products Path</b>，修改到指定位置。例如，`$(PROJECT_DIR)/Frameworks`，这里Frameworks文件夹需要提前创建好，否则Xcode不会自动创建。

#### （2）如何编译none-modular framework
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择framework对应的target，<b>Build Settings</b>中找到或者搜索<b>Defines Module</b>（`DEFINES_MODULE`），将默认YES换成NO，这样编译出来的framework没有包含Modules文件夹

#### （3）解决redefinition of module 'XXX'

>
.../module.modulemap:1:8: error: redefinition of module 'XXX'
module XXX {    
.../module.modulemap:1:8: note: previously defined here
module XXX {

原因是自定义的modulemap文件不能是`module.modulemap`，应该是Xcode的bug[^1]，可以将`module.modulemap`命名成\<framework\>.modulemap或者其他文件名


#### （3）解决Could not build module 'XXX'

>
Umbrella header for module 'XXX' does not include header 'YYY.h'    
Could not build module 'XXX'

原因是当前编译的 modular framework，引用none-modular framework的头文件。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;选择framework对应的target，<b>Build Settings</b>中找到或者搜索<b>Allow Non-modular Includes In Framwork Modules</b>，将默认NO换成YES。


参考资料

[^1]: http://www.openradar.me/30194818
[^2]: http://blog.bjhomer.com/2015/05/defining-modules-for-custom-libraries.html

