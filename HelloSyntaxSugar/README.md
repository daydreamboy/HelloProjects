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

ibireme的[这篇文章](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)提到一种简便的延迟释放对象的方法，举个例子，如下。详见`DelayReleaseObjectViewController`

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

`__attribute__`是编译器的指令，其结构是两对括号构成[^11]，如`__attribute__((xxx))`。xxx是属性名，如果有多个属性名，则用逗号分隔，如`__attribute__((xxx, yyy))`。举个例子，如下

```c
// Send printf-like message to stderr and exit
extern void die(const char *format, ...)
  __attribute__((noreturn, format(printf, 1, 2)));
```

上面有两个属性名，分别是noreturn和format

从GCC开始就支持`__attribute__`，而LLVM继续支持`__attribute__`，并且增加很多属性名。



### （2）常用属性的使用

常用属性列表，如下

| 属性                          | 系统别名   | 作用                                                      |
| ----------------------------- | ---------- | --------------------------------------------------------- |
| `cleanup`                     |            |                                                           |
| `objc_boxable`                | CG_BOXABLE | 用于标记struct或union，可以使用@()语法糖封箱成NSValue对象 |
| `objc_requires_super`         |            | 该方法里面需要调用super方法                               |
| `objc_subclassing_restricted` |            | 禁止某个类被继承                                          |
|                               |            |                                                           |





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





\_\_attribute\_\_ ((\_\_cleanup\_\_(\<callback\>)))的用法



示例代码，见**GCCAttributeCleanupViewController**



## 9、Objective-C常见关键词

### （1）@package



### （2）template

template在Objective-C++是关键词，不能作为参数使用，否则编译器（Xcode 10）会报错。

举个例子，如下

```objective-c
- (void)callDelegateOfHookHandleWithTemplate:(TemplateModel *)template data:(DataModel *)data nameSpace:(NSString *)nameSpace { // error: expected identifier; 'template' is a keyword in Objective-C++
}
```



## 10、Objective-C常用方法命名方式



| 格式                             | 作用                       | 说明 |
| -------------------------------- | -------------------------- | ---- |
|                                  |                            |      |
|                                  |                            |      |
| callDelelgateOf`protocol_method` | 调用delegate方法的包装方法 |      |



## 11、随机化处理[^4]



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



## 12、extern "C"[^5]



## 13、数据类型最大最小值[^6]

limits.h提供整型数据类型最大最小值的宏定义

float.h提供float型数据类型最大最小值的宏定义



## 14、__has_feature检查

__has_feature(xxx)可以传入下面的参数，来检查编译是否支持某个特性。

| 参数                               | 作用                                                |
| ---------------------------------- | --------------------------------------------------- |
| objc_default_synthesize_properties | 检查声明@property是否自动生成setter和getter方法[^9] |
| objc_array_literals                | 检查是否支持数组字面常量[^10]                       |
| objc_dictionary_literals           | 检查是否支持词典字面常量[^10]                       |
| objc_subscripting                  | 检查是否支持下标引用[^10]                           |











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



