# HelloSyntaxSugar

[TOC]


## 1、char字面常量，存放多个字符

​      char字面常量，存放多个字符。例如'abc'、'abcd'、'abcde'等。根据赋值的数据类型长度和编译器选择little endian或big endian，决定是从前还是从后选择N个字符，赋值到对应类型的变量中[^7]。

举个例子，如下

```c
unsigned value;
char* ptr = (char*)&value;

value = 'ABCD';
printf("'ABCD' = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], value);
    
value = 'ABC';
printf("'ABC'  = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], value);
```

> unsigned类型，即unsigned int类型，可以存放4个char类型



在MacOS用Xcode编译上面的代码，输出结果，如下

'ABCD' = 44434241 = 41424344    
'ABC'  = 43424100 = 00414243



得出如下规则：

由于是little endian，低地址的字节放在word（4个字节）的低位，总是从后到前取最后4个字节的数据，如果不满足4个字节，填充0x00。



## 2、C++ 11支持Raw String

C++ 11支持Raw String，在.mm文件中可以使用R"\<LANG\>(raw string)\<LANG\>"语法，用于直接写非转义的C字符串。如下

```objective-c
static NSString *jsonString = @R"JSON(
{
    "glossary": {
        "title": "example glossary",
        "GlossDiv": {
            "title": "S",
            "GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "Acronym": "SGML",
                    "Abbrev": "ISO 8879:1986",
                    "GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                    },
                    "GlossSee": "markup"
                }
            }
        }
    }
}
)JSON";
```

上面的@符号将C字符串转成NSString类型。



## 3、表示NaN

math.h头文件提供NaN（Not A Number），有时候需要这种特殊值来占位或者其他用途。

### （1）NaN值的表示

使用NAN宏或者nan(NULL)返回一个NaN值

### （2）判断是否NaN

NaN相关函数

```c
extern float nanf(const char *);
extern double nan(const char *);
extern long double nanl(const char *);
```

或者直接使用isnan(x)宏

### （3）打印NaN值

NaN值的字符串输出总是nan。系统函数一般都处理过，然后输出成nan。

```objective-c
double maybeNumber = nan(NULL);
    
NSLog(@"%f", maybeNumber); // nan

CGRect rect = CGRectMake(maybeNumber, maybeNumber, maybeNumber, maybeNumber);
NSLog(@"%@", NSStringFromCGRect(rect)); // {{nan, nan}, {nan, nan}}
```
>
参考资料：https://stackoverflow.com/questions/9402348/how-to-return-a-nil-cgfloat



## 4、延迟释放对象

ibireme的[这篇文章](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)提到一种简便的延迟释放对象的方法。主要思路是，在延迟释放对象的持有者要释放时，将延迟释放的对象，用本地变量临时强引用一下，同时将本地变量放到block中引用，并将延迟释放对象设置为nil。

举个例子，如下。

```objective-c
- (void)dealloc {
    MyObject *tempObject = _myObject;
    _myObject = nil;
    NSLog(@"start to dealloc");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Note: use it to avoid warning
        [tempObject class];
    });
}
```

> 示例代码，见DelayReleaseObjectViewController

文章也提到，如果对象可以在后台线程释放，可以放在非主线程去释放这个对象，这样可以减少主线程的开销。



## 5、使用@property

​      一般来说，定义@property会自动synthesize setter和getter方法，同时定义一个名为`_property`的实例变量。

> 1. 手动实现setter或者getter方法，其中之一，这个`_property`实例变量也是自动合成的。
> 2. 如果同时实现setter和getter方法，需要手动synthesize @property
> 3. 可以使用`__has_feature(objc_default_synthesize_properties)`来检查编译器是否此特性[^9]



### （1）手动synthesize @property         

​        手动同时实现setter和getter方法，编译器不再自动合成`_property`实例变量，当用到`_property`实例变量会在编译时报错。

举个例子，如下

```objective-c
@interface SynthesizePropertyViewController ()
@property (nonatomic, copy) NSString *propertyWithBothCustomSetterAndGetter;
@end

#pragma mark - Both Setter and Getter

- (void)setPropertyWithBothCustomSetterAndGetter:(NSString *)propertyWithBothCustomSetterAndGetter {
    // Compile Error: Use of undeclared identifier '_propertyWithBothCustomSetterAndGetter'; did you mean 'propertyWithBothCustomSetterAndGetter'?
    _propertyWithBothCustomSetterAndGetter = propertyWithBothCustomSetterAndGetter;
}

- (NSString *)propertyWithBothCustomSetterAndGetter {
    // Compile Error: Use of undeclared identifier '_propertyWithBothCustomSetterAndGetter'
    return _propertyWithBothCustomSetterAndGetter;
}
```

解决方法：这种情况需要手动合成`_property`实例变量，如下

```objective-c
@synthesize propertyWithBothCustomSetterAndGetter = _propertyWithBothCustomSetterAndGetter;
```



### （2）子类和父类不共用一个实例变量，需要手动synthesize @property

​        一般来说，父类定义@property后，自动合成的实例变量，继承父类的子类不能直接使用`_ivar`方式访问，但是可以通过`super`关键字来访问。但需要注意的是，子类重写了setter或getter方法，需要调用对应的super方法。

​      举个错误的例子，如下

```objective-c
- (void)setResourceDicPath:(NSString *)resourceDicPath {
    // WARNING: missing call [super setXXX:]
    self.myManager.directoryPath = resourceDicPath;
}
```

这里父类的_resourceDicPath没有被赋值。有两种方法可以解决这个问题。

方法一：调用super方法

方法二：在子类中手动合成实例变量，让子类和父类不共用一个实例变量。调试检查如下

![](images/子类和父类不共用一个实例变量.png)

可以看出子类和父类有各自的_resourceDicPath2实例变量。



### （3）Ivar在子类中访问[^3]

* property合成的Ivar变量是private类型，不能在子类使用_ivar访问。

  > 示例代码见Tests_AccessIvarOfProperty.m

* 在父类的头文件.h中，显式声明Ivar变量，则子类可以使用_ivar访问。同时定义对应的属性，则子类可以使用self来访问Ivar变量

  > 示例代码，见Tests_AccessPublicIvar.m

  * 这种做法在.h头文件暴露了Ivar变量，可能子类也只是内部使用Ivar变量，所以可以使用扩展的方式。

* 在父类的扩展头文件baseClass_internal.h中，显式声明Ivar变量同时标记为protected，子类的.m文件引入父类的头文件和扩展头文件xx_internal.h，可以访问Ivar变量。对外面暴露父类和子类的.h文件，不暴露父类的xx_internal.h

  > 示例代码，见Tests_AccessPublicIvar.m



## 6、使用@synthesize

@synthesize的作用是指示编译自动生成对应的实例变量，以及setter和getter方法[^8]。

类的定义中声明@property，就可以不用使用@synthesize，但是如果类实现协议中的@property，就需要使用@synthesize





## 7、使用Category

​         Category方法的使用，一般是创建Category Class，定义新的方法（即分类方法），这样Primary Class也拥有这个方法。

​        但是Category方法也存在覆盖Primary Class方法的情况，因此有两种情况：（1）分类方法不覆盖主类方法；（2）分类方法覆盖主类方法。

| Primary Class | Category Class | 说明                                         |
| ------------- | -------------- | -------------------------------------------- |
| ✘             | ✔︎              | 使用分类方法                                 |
| ✔︎             | ✔︎              | 总是使用分类方法，编译会有覆盖主类方法的警告 |



如果子类中也定义分类方法，将有下面组合

| Inheritance   | Primary Class | Category Class | 说明 |
| ------------- | ------------- | -------------- | ---- |
| BaseClass     | ✔︎             | ✔︎              |      |
| DerivedClass1 | ✘             | ✔︎              |      |
| DerivedClass2 | ✔︎             | ✘              |      |
| DerivedClass3 | ✔︎             | ✔︎              |      |
| DerivedClass4 | ✘             | ✘              |      |





## 8、使用`__attribute__`

### （1）介绍`__attribute__`

`__attribute__`指令可以修饰C/C++和Objective-C的代码，用于代码优化、消除警告、提高代码可读性等。

参考Twitter上的这篇文章[^13]的描述，如下

> The __attribute__ directive is used to decorate a code declaration in C, C++ and Objective-C programming languages. This gives the declared code additional attributes that would help the compiler incorporate optimizations or elicit useful warnings to the consumer of that code.

简单来说，`__attribute__`指令为编译器提供上下文。



`__attribute__`是编译器提供的指令，其结构是两对括号构成[^11]，如`__attribute__((xxx))`。xxx是属性名，如果有多个属性名，则用逗号分隔，如`__attribute__((xxx, yyy))`。举个例子，如下

```c
// Send printf-like message to stderr and exit
extern void die(const char *format, ...)
  __attribute__((noreturn, format(printf, 1, 2)));
```

上面有两个属性名，分别是noreturn和format

从GCC开始就支持`__attribute__`，而LLVM继续支持`__attribute__`，并且增加很多属性名。



### （2）常用属性的使用

常用属性列表，如下

| 属性                          | 系统别名   | 作用                                                         |
| ----------------------------- | ---------- | ------------------------------------------------------------ |
| `annotate("xxx")`             |            | https://blog.quarkslab.com/implementing-a-custom-directive-handler-in-clang.html |
| `cleanup`                     |            |                                                              |
| `const`                       |            | 标记某个函数的返回值，仅依赖于函数的参数，因此运行时采用缓存直接返回之前计算过的值 |
| `constructor`和`destructor`   |            | 在main之前，调用用`constructor`修饰的函数<br/>在main之后，调用用`destructor`修饰的函数 |
| `deprecated`                  |            |                                                              |
| `enable_if`                   |            | 用于静态检查函数的参数，是否满足特定判断if条件               |
| `objc_boxable`                | CG_BOXABLE | 用于标记struct或union，可以使用@()语法糖封箱成NSValue对象    |
| `objc_requires_super`         |            | 该方法里面需要调用super方法                                  |
| `objc_runtime_name`           |            | 用于重命名OC类或OC协议                                       |
| `objc_subclassing_restricted` |            | 禁止某个类被继承                                             |
| `overloadable`                |            | 用于重载C函数，编译器根据参数类型匹配对应的函数调用          |
| `weak`                        |            |                                                              |



// TODO

https://prafullkumar77.medium.com/clang-attributes-4f20cdd1e04



#### a. `cleanup`



#### b. `objc_boxable`

`objc_boxable`用于标记struct或union，可以使用@()语法糖封箱成NSValue对象。

举个例子，如下

```objective-c
// Note: make some_struct into objc_boxable
struct __attribute__((objc_boxable)) some_struct {
    int i;
};

// Note: some_union into objc_boxable
union __attribute__((objc_boxable)) some_union {
    int i;
    float f;
};

// Note: make existing type into objc_boxable
typedef struct __attribute__((objc_boxable)) CGRect WCRect;

- (void)test_WCRect {
    NSValue *value;
    CGRect rect;
    
    CGRect rect2 = CGRectMake(0, 0, 100, 100);
    value = @(rect2);
    NSLog(@"%@", value);
    rect = [value CGRectValue];
    NSLog(@"{%f, %f, %f, %f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    WCRect rect3 = CGRectMake(0, 0, 200, 200);
    value = @(rect3);
    NSLog(@"%@", value);
    rect = [value CGRectValue];
    NSLog(@"{%f, %f, %f, %f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}
```

> 示例代码，见Tests_objc_boxable.m



#### c. `objc_requires_super`

`objc_requires_super`用标记该方法，在重写时，必现使用super调用父类方法，否则会产生警告[^12]

举个例子，如下

```objective-c
@interface Tests_objc_requires_super_BaseClass : NSObject
- (void)aMethodNeedCallSuperWhenOverride __attribute__((objc_requires_super));
@end
@implementation Tests_objc_requires_super_BaseClass
- (void)aMethodNeedCallSuperWhenOverride {
}
@end

@interface Tests_objc_requires_super_DerivedClass : Tests_objc_requires_super_BaseClass
@end
@implementation Tests_objc_requires_super_DerivedClass
- (void)aMethodNeedCallSuperWhenOverride {
    // Note: a warning here if not call [super aMethodNeedCallSuperWhenOverride]
}
@end
```

> 示例代码，见Tests_objc_requires_super.m



#### d. `objc_subclassing_restricted`

`objc_subclassing_restricted`用标记该类不能被继承使用，否则编译时产生错误[^12]

举个例子，如下

```objective-c
__attribute__((objc_subclassing_restricted))
@interface ClassNotSuppoertInheritance : NSObject
@end
@implementation ClassNotSuppoertInheritance
@end

@interface DerivedFromClassNotSuppoertInheritance : ClassNotSuppoertInheritance
@end
@implementation DerivedFromClassNotSuppoertInheritance
@end
```

> 示例代码，见Tests_objc_subclassing_restricted.m





#### e. `const`

`const`用于标记函数的返回值，完全依赖它的参数，而且内部不依赖其他变量。这样编译器可以在调用的地方，增加缓存，用于提高性能。

NSHipster的这篇文章[^11]对const描述，如下

> The `const` attribute specifies that a function does not examine any values except their arguments, and have no effects except the return value. 



举个例子，如下

```c
int square(int n) __attribute__((const));
```

求平方的函数，它的返回值仅依赖输入的参数，因此非常适合使用`const`修饰。

但是需要注意的是

* 如果函数的参数是指针，并且内部会检查指针指向的数据，则一定不能使用`const`修饰
* 如果函数是非`const`修饰，则调用它的函数同样不能使用`const`修饰
* 如果函数的返回值是void，则使用`const`修饰是没有意义的

> Note that a function that has pointer arguments and examines the data pointed to must not be declared const. Likewise, a function that calls a non-`const` function usually must not be `const`. It does not make sense for a `const` function to return `void`.



如果错误地使用`const`，则会产生非常难调试排查的bug，而且一般在Debug编译下不会复现，则在使用某些高度优化的编译选项的app才出现。

参考Twitter上的这篇文章[^13]的描述，如下

> The worst of this is that the optimization that would cause this crash will only happen in builds that are highly optimized. Since debug builds often have optimizations turned down, you can run your app in a debugger forever and never reproduce it, making this bug, like most __attribute__ based bugs, very hard to figure out and fix.



#### f. `constructor`和`destructor`

构造器`constructor`和析构器`destructor`，使用这两个属性修饰的函数会在分别在可执行文件（包括动态库）load和 unload时被调用，可以理解为在 `main()` 函数调用前和 return 后执行[^12]。



##### `constructor`和`+load`的顺序[^12]

`constructor`在`+load`的之后，如下

> constructor 和 `+load` 都是在 main 函数执行前调用，但 `+load` 比 constructor 更加早一丢丢，因为 dyld（动态链接器，程序的最初起点）在加载 image（可以理解成 Mach-O 文件）时会先通知 `objc runtime` 去加载其中所有的类，每加载一个类时，它的 `+load` 随之调用，全部加载完成后，dyld 才会调用这个 image 中所有的 constructor 方法。

可以看出`constructor`比`+load`更适合进行swizzle。



#### g. `enable_if`

`enable_if`用于静态检查函数的参数是否满足特定条件，一般比较适合检查整型枚举值的参数。

> 因为使用到函数的参数，`enable_if`只能放在函数名后面修饰



举个例子，如下

```objective-c
typedef NS_ENUM(NSInteger, MyEnumType) {
    MyEnumTypeA,
    MyEnumTypeB,
};

static NSString *NSStringFromMyEnumType(MyEnumType type) __attribute__((enable_if(type > MyEnumTypeA - 1 && type < MyEnumTypeB + 1, "枚举值不在范围中"))) {
    switch (type) {
        case MyEnumTypeA:
            return @"A";
        case MyEnumTypeB:
            return @"B";
        default:
            break;
    }
    return nil;
}

- (void)test_enable_if {
    NSString *string;
    __unused NSInteger type = 200;
    
    string = NSStringFromMyEnumType(MyEnumTypeA);
    string = NSStringFromMyEnumType(MyEnumTypeB);
    
    // Errors: error: no matching function for call to 'NSStringFromMyEnumType'
    /*
    string = NSStringFromMyEnumType(-1);
    string = NSStringFromMyEnumType(100);
    string = NSStringFromMyEnumType(type);
     */
}
```

但是编译报错不是`enable_if`的第二个字符串参数，导致编译报错提示有点不友好。



#### h. `overloadable`

`overloadable`用于重载C函数，编译器根据参数类型匹配对应的函数调用。

举个例子，如下

```objective-c
__attribute__((overloadable))
static void logAnything(id obj) {
    NSLog(@"id: %@", obj);
}

__attribute__((overloadable))
static void logAnything(int number) {
    NSLog(@"int: %@", @(number));
}

__attribute__((overloadable))
static void logAnything(CGRect rect) {
    NSLog(@"CGRect: %@", NSStringFromCGRect(rect));
}

- (void)test_overloadable {
    logAnything(@[@"1", @"2"]);
    logAnything(233);
    logAnything(CGRectMake(1, 2, 3, 4));
}
```

// TODO: https://github.com/mattt/WebPImageSerialization/blob/master/WebPImageSerialization/WebPImageSerialization.m



#### i. `objc_runtime_name`

`objc_runtime_name`可以修饰OC的类或协议进行重命名，一般用于代码混淆、代码注解等。

举个例子，如下

```objective-c
__attribute__((objc_runtime_name("7eceb275788590faefc1097c0f903ce5")))
@protocol MySecretProtcol <NSObject>
- (void)test_objc_runtime_name;
@end

__attribute__((objc_runtime_name("544cd1f719a0cb56dce50fd51b39852d")))
@interface MySecretClass : NSObject
@end

- (void)test_objc_runtime_name {
    NSLog(@"class: %@", NSStringFromClass([MySecretClass class])); // class: 544cd1f719a0cb56dce50fd51b39852d
    NSLog(@"protocol: %@", NSStringFromProtocol(@protocol(MySecretProtcol))); // protocol: 7eceb275788590faefc1097c0f903ce5
}
```

值得注意的是，重命名可以打破编译时命名规则，可以使用数字开头。



// TODO: 代码注解示例



\_\_attribute\_\_ ((\_\_cleanup\_\_(\<callback\>)))的用法



示例代码，见**GCCAttributeCleanupViewController**



### （3）让Xcode生成Availability提示

Xcode中按住Option键，同时点击某个方法、类、属性，会弹出相关的文档，其中有一项是Availability（如下图），作用是告知该方法、类或属性，在什么版本引入，在什么版本不推荐使用，方便开发者知晓API版本和系统版本的兼容性。

<img src="images/Xcode的Availability提示.png" style="zoom:50%;" />



下面介绍一些相关的宏，如下表

| 宏                                                           | 修饰内容 | 含义                         |
| ------------------------------------------------------------ | -------- | ---------------------------- |
| NS_AVAILABLE(_mac, _ios)                                     | 方法     | 在mac和ios平台上可用起始版本 |
| NS_AVAILABLE_MAC(_mac)                                       | 方法     | 在mac平台上可用起始版本      |
| NS_AVAILABLE_IOS(_ios)                                       | 方法     | 在ios平台上可用起始版本      |
| NS_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...)   | 方法     |                              |
| NS_DEPRECATED_MAC(_macIntro, _macDep, ...)                   | 方法     |                              |
| NS_DEPRECATED_IOS(_iosIntro, _iosDep, ...)                   | 方法     |                              |
| NS_CLASS_AVAILABLE(_mac, _ios)                               | 类       |                              |
| NS_CLASS_AVAILABLE_IOS(_ios)                                 | 类       |                              |
| NS_CLASS_AVAILABLE_MAC(_mac)                                 | 类       |                              |
| NS_CLASS_DEPRECATED(_mac, _macDep, _ios, _iosDep, ...)       | 类       |                              |
| NS_CLASS_DEPRECATED_MAC(_macIntro, _macDep, ...)             | 类       |                              |
| NS_CLASS_DEPRECATED_IOS(_iosIntro, _iosDep, ...)             | 类       |                              |
| NS_ENUM_AVAILABLE(_mac, _ios)                                | 枚举     |                              |
| NS_ENUM_AVAILABLE_MAC(_mac)                                  | 枚举     |                              |
| NS_ENUM_AVAILABLE_IOS(_ios)                                  | 枚举     |                              |
| NS_ENUM_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...) | 枚举     |                              |
| NS_ENUM_DEPRECATED_MAC(_macIntro, _macDep, ...)              | 枚举     |                              |
| NS_ENUM_DEPRECATED_IOS(_iosIntro, _iosDep, ...)              | 枚举     |                              |



在Foundation.framework中NSObjCRuntime.h定义了一些宏，用于显示Availability，主要有AVAILABLE和DEPRECATED两类，分别标志什么版本开始引入的和什么版本开始弃用的



#### a. 修饰方法



- AVAILABLE类

```objective-c
#define NS_AVAILABLE(_mac, _ios) CF_AVAILABLE(_mac, _ios)
#define NS_AVAILABLE_MAC(_mac) CF_AVAILABLE_MAC(_mac)
#define NS_AVAILABLE_IOS(_ios) CF_AVAILABLE_IOS(_ios)
```

`_MAC`和`_IOS`后缀分别对应Mac OS X和iOS平台，没有后缀则是针对两者平台的。



注意

> 版本号，必须是x_y格式的，例如NS_AVAILABLE_IOS(5_0)则显示iOS (5.0 or later)



- DEPRECATED类

```objective-c
#define NS_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...) CF_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, __VA_ARGS__)
#define NS_DEPRECATED_MAC(_macIntro, _macDep, ...) CF_DEPRECATED_MAC(_macIntro, _macDep, __VA_ARGS__)
#define NS_DEPRECATED_IOS(_iosIntro, _iosDep, ...) CF_DEPRECATED_IOS(_iosIntro, _iosDep, __VA_ARGS__)
```

同样，`_MAC`和`_IOS`后缀分别对应Mac OS X和iOS平台，没有后缀则是针对两者平台的



   与AVAILABLE类，相比DEPRECATED类至少提供引入版本号和弃用版本号，还可以在第三个宏参数提供替换的API，如下图所示

<img src="images/DEPRECATED宏.png" style="zoom:50%;" />

注意

> 弃用版本号必须大于引入版本号，第三个宏参数是可选的



#### b. 修饰类



除了上面通用的AVAILABLE宏和DEPRECATED宏，还有针对类和枚举的AVAILABLE宏和DEPRECATED宏

- NS_CLASS_AVAILABLE_xxx类

```objective-c
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_6 || __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_1) && \
    ((__has_feature(objc_weak_class) || \
     (defined(__llvm__) && defined(__APPLE_CC__) && (__APPLE_CC__ >= 5658)) || \
     (defined(__APPLE_CC__) && (__APPLE_CC__ >= 5666))))
#define NS_CLASS_AVAILABLE(_mac, _ios) __attribute__((visibility("default"))) NS_AVAILABLE(_mac, _ios)
...
#else
#define NS_CLASS_AVAILABLE(_mac, _ios)
...
#endif

#define NS_CLASS_AVAILABLE_IOS(_ios) NS_CLASS_AVAILABLE(NA, _ios)
#define NS_CLASS_AVAILABLE_MAC(_mac) NS_CLASS_AVAILABLE(_mac, NA)
```



* NS_CLASS_DEPRECATED_xxx类

```objective-c
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_6 || __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_1) && \
    ((__has_feature(objc_weak_class) || \
     (defined(__llvm__) && defined(__APPLE_CC__) && (__APPLE_CC__ >= 5658)) || \
     (defined(__APPLE_CC__) && (__APPLE_CC__ >= 5666))))
...
#define NS_CLASS_DEPRECATED(_mac, _macDep, _ios, _iosDep, ...) __attribute__((visibility("default"))) NS_DEPRECATED(_mac, _macDep, _ios, _iosDep, __VA_ARGS__)
#else
...
#define NS_CLASS_DEPRECATED(_mac, _macDep, _ios, _iosDep, ...)
#endif

#define NS_CLASS_DEPRECATED_MAC(_macIntro, _macDep, ...) NS_CLASS_DEPRECATED(_macIntro, _macDep, NA, NA, __VA_ARGS__)
#define NS_CLASS_DEPRECATED_IOS(_iosIntro, _iosDep, ...) NS_CLASS_DEPRECATED(NA, NA, _iosIntro, _iosDep, __VA_ARGS__)
```



举个例子如下图

<img src="images/NS_CLASS_AVAILABLE示例.png" style="zoom:50%;" />

注意：AVAILABLE和DEPRECATED宏，是区分平台的，这里只显示了iOS编译环境下的提示“iOS (5.0 or later)”，另外宏是需要编译的，因此Option+Clicking在头文件中或对应的.m文件有可能Availability不会出现，这时需要在其他文件引入.h文件编译后，在第三方文件（.h或.m文件）中使用该类才会出现Availability提示。



#### c. 修饰枚举



- NS_ENUM_AVAILABLE_xxx类和NS_ENUM_DEPRECATED_xxx类

```objective-c
#define NS_ENUM_AVAILABLE(_mac, _ios) CF_ENUM_AVAILABLE(_mac, _ios)
#define NS_ENUM_AVAILABLE_MAC(_mac) CF_ENUM_AVAILABLE_MAC(_mac)
#define NS_ENUM_AVAILABLE_IOS(_ios) CF_ENUM_AVAILABLE_IOS(_ios)

#define NS_ENUM_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...) CF_ENUM_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, __VA_ARGS__)
#define NS_ENUM_DEPRECATED_MAC(_macIntro, _macDep, ...) CF_ENUM_DEPRECATED_MAC(_macIntro, _macDep, __VA_ARGS__)
#define NS_ENUM_DEPRECATED_IOS(_iosIntro, _iosDep, ...) CF_ENUM_DEPRECATED_IOS(_iosIntro, _iosDep, __VA_ARGS__)
```







## 9、使用`__builtin_xxx`系列函数

​       GCC编译器提供一些内置函数，例如`__builtin_trap`等。这里统称为`__builtin_xxx`系列函数。Clang也支持`__builtin_xxx`系列函数，但是作为可选的。因此需要使用宏`__has_builtin`测试是否编译器支持[^14]，如下

```c
#ifndef __has_builtin         // Optional of course.
  #define __has_builtin(x) 0  // Compatibility with non-clang compilers.
#endif

...
#if __has_builtin(__builtin_trap)
  __builtin_trap();
#else
  abort();
#endif
```



由于，这里只介绍常用的函数，如下

| 函数                       | 作用                                                   | 说明 |
| -------------------------- | ------------------------------------------------------ | ---- |
| `__builtin_return_address` | 获取当前函数的返回地址，即返回后要执行的下个指令的地址 |      |



### （1）`__builtin_return_address`

`__builtin_return_address`函数签名[^15]，如下

```c
void * __builtin_return_address (unsigned int level);
```

注意：level参数只能传0，因为可能会出现crash。GCC文档描述，如下

> Calling this function with a nonzero argument can have unpredictable effects, including crashing the calling program. 

该函数返回值是被调用函数返回到调用处执行的下一个指令的内存地址，如下面截图

![](images/使用__builtin_return_address.png)

current值是get_function_adress函数的内存地址，而return值是下个指令的内存地址。

示例代码，如下

```objective-c
void get_function_address(void)
{
    void *current_function_ptr = get_function_address;
    printf("current: %p\n", current_function_ptr);
    printf("return: %p\n", __builtin_return_address(0));
}

- (void)test__builtin_return_address {
    get_function_address();
}
```







## 10、Objective-C常见关键词

### （1）template

template在Objective-C++是关键词，不能作为参数使用，否则编译器（Xcode 10）会报错。

举个例子，如下

```objective-c
- (void)callDelegateOfHookHandleWithTemplate:(TemplateModel *)template data:(DataModel *)data nameSpace:(NSString *)nameSpace { // error: expected identifier; 'template' is a keyword in Objective-C++
}
```



## 11、Objective-C常用方法命名方式



| 格式                             | 作用                       | 说明 |
| -------------------------------- | -------------------------- | ---- |
| `view`Tapped                     | view单击的方法             |      |
| `view`DoubleTapped               | view双击的方法             |      |
| `UISwitchVarName`Toggled         | UISwitch点击切换的方法     |      |
| callDelelgateOf`protocol_method` | 调用delegate方法的包装方法 |      |



## 12、随机化处理[^4]



经常使用的函数`arc4random`，一般用它来取模得到某个范围的随机值。

```c
uint32_t arc4random(void)
```



更简单的方式，使用`arc4random_uniform`函数

```c
uint32_t
	 arc4random_uniform(uint32_t __upper_bound) __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_3);
```

它随机返回[0, N-1]的随机值



除了获取随机的整型值，也可以通过`drand48`函数获得随机的浮点型数，但是用`srand48`函数必须初始化一次。

```c
srand48(time(0));
double random = drand48();
NSLog(@"%f", random);
```



> 示例代码，见Tests_Random.m



## 13、extern "C"[^5]



## 14、数据类型最大最小值[^6]

limits.h提供整型数据类型最大最小值的宏定义

float.h提供float型数据类型最大最小值的宏定义



## 15、__has_feature检查

__has_feature(xxx)可以传入下面的参数，来检查编译是否支持某个特性。

| 参数                               | 作用                                                |
| ---------------------------------- | --------------------------------------------------- |
| objc_default_synthesize_properties | 检查声明@property是否自动生成setter和getter方法[^9] |
| objc_array_literals                | 检查是否支持数组字面常量[^10]                       |
| objc_dictionary_literals           | 检查是否支持词典字面常量[^10]                       |
| objc_subscripting                  | 检查是否支持下标引用[^10]                           |





## 16、ivar变量

Objective-C实例的内部变量，称为ivar变量（或者实例变量）。一般来说，访问ivar变量，需要通过对应setter和getter方法来访问。



### （1）ivar变量访问级别

ivar变量可以设置访问级别，有4种[^16]，如下

* @private，仅在定义该变量的类中访问。属性的私有变量，就是@private级别
* @protected，在定义该变量的类中以及所有子类中访问。如果定义ivar变量，默认就是@protected级别

* @package，在可执行的包（例如framework）的代码中任意访问，但是在另一个可执行包的编译链接中不能访问
* @public，任意访问



举个例子，如下

@private

```objective-c
@interface AccessPrivateIvar1 : NSObject {
@private
    NSString *_privateIvar;
}
@end
@implementation AccessPrivateIvar1
@end

@interface AccessPrivateIvar2 : AccessPrivateIvar1
@end
@implementation AccessPrivateIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _privateIvar = @"abc"; // Compile Error: Instance variable '_privateIvar' is private
    }
    return self;
}
@end

- (void)test_access_private_ivar {
    AccessPrivateIvar2 *object = [AccessPrivateIvar2 new];
    NSLog(@"%@", object->_privateIvar);  // Compile Error: Instance variable '_privateIvar' is private
}
```



@protected

```objective-c
@interface AccessProtectedIvar1 : NSObject {
@protected
    NSString *_protectedIvar;
}
@end
@implementation AccessProtectedIvar1
@end

@interface AccessProtectedIvar2 : AccessProtectedIvar1
@end
@implementation AccessProtectedIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _protectedIvar = @"abc";
    }
    return self;
}
@end
  
- (void)test_access_protected_ivar {
    __unused AccessProtectedIvar2 *object = [AccessProtectedIvar2 new];
    NSLog(@"%@", object->_protectedIvar);  // Compile Error: Instance variable '_protectedIvar' is protected
}
```



@public

```objective-c
@interface AccessPublicIvar1 : NSObject {
@public
    NSString *_publicIvar;
}
@end
@implementation AccessPublicIvar1
@end

@interface AccessPublicIvar2 : AccessPublicIvar1
@end
@implementation AccessPublicIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _publicIvar = @"abc";
    }
    return self;
}
@end
  
- (void)test_access_public_ivar {
    __unused AccessPublicIvar2 *object = [AccessPublicIvar2 new];
    NSLog(@"%@", object->_publicIvar);
    
    object->_publicIvar = @"123";
    XCTAssertEqualObjects(object->_publicIvar, @"123");
}
```



@package

```objective-c
@interface AccessPackageIvar1 : NSObject {
@package
    NSString *_packageIvar;
}
@end
@implementation AccessPackageIvar1
@end

@interface AccessPackageIvar2 : AccessPackageIvar1
@end
@implementation AccessPackageIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _packageIvar = @"abc";
    }
    return self;
}
@end

#pragma mark -

@interface AccessPackageIvarFromDynamicFramework : DynamicFrameworkClass
@end
@implementation AccessPackageIvarFromDynamicFramework
- (instancetype)init {
    self = [super init];
    if (self) {
        /**
         Undefined symbols for architecture x86_64:
         "_OBJC_IVAR_$_DynamicFrameworkClass._packageIvar", referenced from:
             -[AccessPackageIvarFromStaticLibrary init] in Tests_AccessPackageIvar.o
         */
        //_packageIvar = @"123";
        _publicIvar = @"123";
    }
    return self;
}
@end
  
- (void)test_access_package_ivar {
    __unused AccessPackageIvar2 *object = [AccessPackageIvar2 new];
    NSLog(@"%@", object->_packageIvar);
    
    object->_packageIvar = @"123";
    XCTAssertEqualObjects(object->_packageIvar, @"123");
}

- (void)test_access_public_ivar_from_dynamic_framework {
    __unused AccessPackageIvarFromDynamicFramework *object = [AccessPackageIvarFromDynamicFramework new];
    NSLog(@"%@", object->_publicIvar);
    
    object->_publicIvar = @"123";
    XCTAssertEqualObjects(object->_publicIvar, @"123");
}
```



> 以上代码，见
>
> Tests_AccessPrivateIvar.m
>
> Tests_AccessProtectedIvar.m
>
> Tests_AccessPublicIvar.m
>
> Tests_AccessPackageIvar.m



通过上面的例子，可以4种访问级别，可以归纳如下表

| 级别       | 定义类中访问 | 子类中访问 | 实例外访问 | 可执行bundle代码访问另一个可执行bundle代码（子类中访问、实例外访问） |
| ---------- | ------------ | ---------- | ---------- | ------------------------------------------------------------ |
| @private   | ✅            | ❌          | ❌          | ❌                                                            |
| @protected | ✅            | ✅          | ❌          | ❌                                                            |
| @package   | ✅            | ✅          | ✅          | ❌                                                            |
| @public    | ✅            | ✅          | ✅          | ✅                                                            |



### （2）访问私有ivar变量

根据上面一节，可以看到@private修饰的ivar变量访问限制是最小的，因此如果要通过实例对象来访问私有ivar变量，需要一些hook操作。

目前有下面几种方式可以实现[^17]

* 直接使用指针地址
* 通过runtime api（`class_getInstanceVariable`和`object_getIvar`）
* 通过KVC
* 声明ivar变量为@public



以访问下面两个私有变量为例

```objective-c
@implementation HiddenPrivateIvarClass {
@private
    NSString *_name;
    NSString *_job;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"w";
        _job = @"hacker";
    }
    return self;
}

@end
```



#### a. 直接使用指针地址

由于Objective-C对象的内存都是分配在堆上，因此根据实例对象的地址，加上特定的偏移量，就能计算出实例变量在内存的地址。

示例代码，如下

```objective-c
- (void)test_hook_by_pointer_arithmetic {
    HiddenPrivateIvarClass *foo = [[HiddenPrivateIvarClass alloc] init];
    
    __unsafe_unretained NSString *name = (__bridge id)*(void **)((__bridge void *)foo + 8);
    NSLog(@"name: %@", name);
    XCTAssertEqualObjects(name, @"w");
    
    __unsafe_unretained NSString *job = (__bridge id)*(void **)((__bridge void *)foo + 16);
    NSLog(@"job: %@", job);
    XCTAssertEqualObjects(job, @"hacker");
}
```

说明

> 1. 每个Objective-C对象默认有个isa变量，在64bit系统中，isa占8个字节，因此计算第一个实例变量的偏移量是8
> 2. 在ARC下，需要使用`__unsafe_unretained`修饰获取到ivar变量对象，不需要持有该对象
> 3. 上面这种方法，获取到实例变量不一定是Objective-C对象，也可能是基本类型，容易产生内存问题，因此不适合用于生产中



#### b. 通过runtime api

Objective-C的runtime提供获取实例变量的API，主要通过`class_getInstanceVariable`和`object_getIvar`这两个函数。



在runtime中，实例变量类型定义为Ivar，如下

```objective-c
/// An opaque type that represents an instance variable.
typedef struct objc_ivar *Ivar;
```



通过`class_getInstanceVariable`函数，如下

```objective-c
OBJC_EXPORT Ivar _Nullable
class_getInstanceVariable(Class _Nullable cls, const char * _Nonnull name)
    OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);
```

可以根据实例变量名获取到Ivar。

注意

> class_getInstanceVariable是class_系列函数，可以不用传实例对象



通过`object_getIvar`函数，如下

```objective-c
OBJC_EXPORT id _Nullable
object_getIvar(id _Nullable obj, Ivar _Nonnull ivar) 
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
```

可以拿到实例变量。

注意

> 如果实例变量是基本类型，则不能使用`object_getIvar`函数，否则返回的地址并不是实例对象的。



这篇SO[^18]给一个方式来获取基本类型的实例变量，基本思路还是直接使用指针地址，加偏移量来计算，然后强制转成基本类型的变量。



针对实例变量为对象类型和基本类型的情况。举个例子，如下

```objective-c
- (void)test_hook_by_runtime_api {
    HiddenPrivateIvarClass *foo = [[HiddenPrivateIvarClass alloc] init];
    
    // Case 1: object ivar
    Ivar nameIVar = class_getInstanceVariable([foo class], "_name");
    NSString *name = object_getIvar(foo, nameIVar);
    NSLog(@"name: %@", name);
    XCTAssertEqualObjects(name, @"w");
    
    // Case 2: primitive ivar
    CGSize outSize;
    Ivar sizeIVar = class_getInstanceVariable([foo class], "_size");
    ptrdiff_t offset = ivar_getOffset(sizeIVar);
    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)foo;
    outSize = *((CGSize *)(stuffBytes + offset));
    XCTAssertTrue(outSize.width == 1);
    XCTAssertTrue(outSize.height == 2);
}
```



















## References

[1]: https://stackoverflow.com/questions/34574933/a-good-and-idiomatic-way-to-use-gcc-and-clang-attribute-cleanup-and-point
[ 2 ]: http://echorand.me/site/notes/articles/c_cleanup/cleanup_attribute_c.html

[^3]:http://blog.benjamin-encz.de/post/objective-c-backing-ivars-subclasses/

[^4]:https://nshipster.com/random/

[^5]:https://stackoverflow.com/questions/1041866/what-is-the-effect-of-extern-c-in-c

[^6]:https://stackoverflow.com/questions/2053843/min-and-max-value-of-data-type-in-c

[^7]:https://stackoverflow.com/questions/6944730/multiple-characters-in-a-character-constant
[^8]:https://stackoverflow.com/questions/14658142/purpose-of-synthesize
[^9]:http://clang.llvm.org/docs/LanguageExtensions.html#objective-c-autosynthesis-of-properties
[^10]:http://clang.llvm.org/docs/LanguageExtensions.html#object-literals-and-subscripting
[^11]:https://nshipster.com/__attribute__/
[^12]:https://blog.sunnyxx.com/2016/05/14/clang-attributes/

[^13]:https://blog.twitter.com/engineering/en_us/a/2014/attribute-directives-in-objective-c.html

[^14]:https://clang.llvm.org/docs/LanguageExtensions.html#feature-checking-macros
[^15]:https://gcc.gnu.org/onlinedocs/gcc/Return-Address.html

[^16]:https://useyourloaf.com/blog/private-ivars/
[^17]:http://jerrymarino.com/2014/01/31/objective-c-private-instance-variable-access.html

[^18]:https://stackoverflow.com/a/24107536



