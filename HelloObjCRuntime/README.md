# Objective-C Runtime
[TOC]

## 1、Runtime分析

### （1）分析selector

在objc.h头文件中，SEL被定义为结构体指针。注释上说SEL是opaque类型，即对外不透明的。

```objective-c
/// An opaque type that represents a method selector.
typedef struct objc_selector *SEL;
```

查看objc-sel.mm的[sel_getName函数源码](https://github.com/opensource-apple/objc4/blob/master/runtime/objc-sel.mm#L118)，可以看出SEL指向的实际是C字符串。

```objective-c
const char *sel_getName(SEL sel) 
{
    if (!sel) return "<null selector>";
    return (const char *)(const void*)sel;
}
```

如果强制将SEL类型转成char *，则Xcode会给出一个warning，如下

```objective-c
string = (char *)selector; // Cast of type 'SEL' to 'char *' is deprecated; use sel_getName instead
XCTAssertTrue(strcmp("compare:", string) == 0);
```



解决方法1：参考warning提示，使用sel_getName函数获取C字符串，注意返回值类型是const char *

解决方法2：参考源码的方式，两次类型转换，可以消除warning（Xcode 10.2），如下

```objective-c
string = (const char *)(const void*)selector; // Note: no warning here
XCTAssertTrue(strcmp("compare:", string) == 0);
```

示例代码，见Test_selector.m



### （2）分析IMP

​      IMP在objc.h中定义为一个函数指针，值得注意的是，它有两种函数签名。一般OBJC_OLD_DISPATCH_PROTOTYPES宏不会生效，它的签名是`void (*IMP)(void /* id, SEL, ... */ )`

```objective-c
/// A pointer to the function of a method implementation. 
#if !OBJC_OLD_DISPATCH_PROTOTYPES
typedef void (*IMP)(void /* id, SEL, ... */ ); 
#else
typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...); 
#endif
```

​        注释上说IMP对应方法的实现，实际上签名为`void (*)(void)`的函数指针可以转成任意签名的函数指针，然后调用这个函数指针，可以调用任意OC方法。

举个例子，如下

```objective-c
- (NSInteger)anOCMethod:(NSInteger)arg {
    printf("anOCMethod called\n");
    return arg + 1;
}

- (void)test_check_IMP {
    IMP imp;
    
    // Case 1
    imp = class_getMethodImplementation([Test_IMP class], @selector(anOCMethod:));
    imp();
    
    // Case 2
    typeof(self) object = [[[self class] alloc] init];
    NSInteger (*func)(id, SEL, NSInteger) = (NSInteger (*)(id, SEL, NSInteger))imp;
    NSInteger result = func(object, @selector(anOCMethod:), 5);
    XCTAssertTrue(result == 6);
}
```

示例代码，见Test_IMP.m



### （3）分析weak变量

不能在dealloc中使用weak变量

```objective-c
@implementation Test_weak

- (void)dealloc {
    __weak typeof(self) weak_self = self; // ERROR: crash here
    NSLog(@"%@", weak_self);
}

#pragma mark -

- (void)test_weak_cause_crash_in_dealloc {
    {
        Tests_weak *object = [[Tests_weak alloc] init];
        NSLog(@"%@", object);
    }
    // Note: release the object after the end of code block
}

@end
```

控制台出现下面提示，如下

```
objc[26150]: Cannot form weak reference to instance (0x600000ebc4c0) of class Tests_weak. It is possible that this object was over-released, or is in the process of deallocation.
```

提示信息"Cannot form weak reference to instance..."在**weak_register_no_lock**方法中，可以查看weak_register_no_lock的[源码](<https://github.com/opensource-apple/objc4/blob/master/runtime/objc-weak.mm#L377>)。

具体分析，见下面"dealloc中创建weak self变量导致Crash"和"获取weak变量返回nil"。



### （4）分析self的类型

self是Objective-C方法中很特殊的变量，在ARC环境下，self实际上有两种类型：

* 在非init family方法中，self是`__unsafe_unretained`类型
* 在init family方法中，self是`__strong`类型

Clang文档给出关于self的解释[^4]，如下

> The `self` parameter variable of an non-init Objective-C method is considered [externally-retained](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-misc-externally-retained) by the implementation. It is undefined behavior, or at least dangerous, to cause an object to be deallocated during a message send to that object. In an init method, `self` follows the :ref:`init family rules<arc.family.semantics.init>`.
>
> Rationale
>
> The cost of retaining `self` in all methods was found to be prohibitive, as it tends to be live across calls, preventing the optimizer from proving that the retain and release are unnecessary — for good reason, as it’s quite possible in theory to cause an object to be deallocated during its execution without this retain and release. Since it’s extremely uncommon to actually do so, even unintentionally, and since there’s no natural way for the programmer to remove this retain/release pair otherwise (as there is for other parameters by, say, making the variable `objc_externally_retained` or qualifying it with `__unsafe_unretained`), we chose to make this optimizing assumption and shift some amount of risk to the user.

​        理解下文档上的意思，有下面几点

* 在非init family方法中，self被认为是`objc_externally_retained`变量或者`__unsafe_unretained`变量，而且为了性能考虑，在非init family方法中，都不会retain和release self变量。所以self指向的对象，如果释放了，在非init family方法中，访问self变量会产生EXC_BAD_ACCESS错误

  * Xcode（Xcode 10.2）的llvm并不支持objc_externally_retained变量修饰符，[这里]([http://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-misc-externally-retained](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-misc-externally-retained))给出测试的代码

    > ```objective-c
    > #if __has_attribute(objc_externally_retained)
    > // Use externally retained...
    > #endif
    > ```

* 在init family方法中，self按照init family rules规则。文档这里[^5]介绍了init family rules，如下

  > Methods in the `init` family implicitly [consume](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-objects-operands-consumed) their `self` parameter and [return a retained object](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-object-operands-retained-return-values). Neither of these properties can be altered through attributes.

意思是init family方法中，返回都是retained对象，即引用计数会加1。

​     为了验证self变量在不同方法中有不同的类型，使用CoreFoundation中的`CFGetRetainCount`函数检查retainCount

> 在ARC下，Xcode编译器禁止使用NSObject的retainCount方法



```objective-c
- (void)test_initMethods {
    Test_retainCount *object = [[self class] alloc];
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    
    [object setupWithSomething];
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    
    object = [object initWithCaseName:@"test_initMethods"] ;
    NSLog(@"%p retain count: %d", object, (int)CFGetRetainCount((__bridge CFTypeRef)(object)));
    XCTAssertTrue(CFGetRetainCount((__bridge CFTypeRef)(object)) == 1);
    ...
}
```

​       在initWithCaseName方法中self的引用计数加1，而setupWithSomething方法中self的引用计数不变。具体代码，见Test_retainCount.m。



### （5）分析toll-free bridge转换

​        对于基础对象类型，Objective-C的对象和CoreFoundation的对象是可以相互转换的。简单来说，CFTypeRef和id之间可以转换，CFStringRef和NSString之间可以转换，等等。

以CFStringRef和NSString之间转换的为例，分析下它们的内存对象。

```objective-c
- (void)test {    
    CFStringRef cfString = CFSTR("hello, world");
    __unsafe_unretained NSString *nsString = (__bridge id)cfString;
} // Note: make a breakpoint here
```

使用__unsafe_unretained为了去掉多余的retain和release调用，在arm64下使用汇编模式调试（Debug -> Debug Workflow -> Always Show Disassembly），如下

```assembly
Test`-[Test_bridge test]:
    0x1050cdeac <+0>:  sub    sp, sp, #0x20             ; =0x20 
    0x1050cdeb0 <+4>:  adrp   x8, 7
    0x1050cdeb4 <+8>:  add    x8, x8, #0xe0             ; =0xe0 
    0x1050cdeb8 <+12>: str    x0, [sp, #0x18]
    0x1050cdebc <+16>: str    x1, [sp, #0x10]
    0x1050cdec0 <+20>: str    x8, [sp, #0x8]
    0x1050cdec4 <+24>: ldr    x8, [sp, #0x8]
    0x1050cdec8 <+28>: str    x8, [sp]
->  0x1050cdecc <+32>: add    sp, sp, #0x20             ; =0x20 
    0x1050cded0 <+36>: ret    
```

在test函数调用结束时，查看sp寄存器的地址0x000000016b528de0，使用View Memory查看该地址，如下

![](images/toll-free bridge.png)

可以看出NSString*变量和CFStringRef变量的值是一样的，都指向同一个对象。



## 2、常用技巧

### （1）内存地址转成对象[^1]

```objective-c
NSString *address = textField.text;

__unsafe_unretained NSObject *object;
sscanf([address cStringUsingEncoding:NSUTF8StringEncoding], "%p", &object);

NSString *debugDescriton = [object debugDescription];

NSLog(@"%@", debugDescriton);
```

这里使用`sscanf`函数将字符串内地地址，设置到NSObject对象的地址，改写了该对象的栈上地址。



注意

> 1. 这里的object指针需要标记为`__unsafe_unretained`，防止当超过object的作用域时，ARC将object引用计数减1，导致后面发生内存错误
> 2. 即使标记`__unsafe_unretained`，当object指针的值不是一个合法对象内地地址时，调用`[object debugDescription]`会出现`EXC_BAD_ACCESS (code=1, address=0xXXX)`



### （2）分类添加属性



```objective-c
// .h
@interface NSString (Addition)

@property (nonatomic, retain) NSString *defaultHashKey;
- (void)printHashKey;

@end

// .m
#import <objc/runtime.h>

@implementation NSString (Addition)

static char const * const ObjectTagKey = "ObjectTag";

- (NSString *)defaultHashKey {
    return objc_getAssociatedObject(self, ObjectTagKey);
}

- (void)setDefaultHashKey:(NSString *)hashKey {
    objc_setAssociatedObject(self, ObjectTagKey, hashKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)printHashKey {
    NSLog(@"the hash key is: %@", self.defaultHashKey);
}

@end
```



```objective-c
#import "NSString+Addition.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *string = [NSString string] ;
        string.defaultHashKey = @"Ciao";
        [string printHashKey] ;
    }
    return 0;
}
```



### （3）判断一个类是否重写了父类方法[^6]

​        通过比较子类和父类的selector对应的IMP地址是否是一样的，如果IMP地址不一样，则子类重写该selector对应的方法。

```objective-c
+ (BOOL)checkIfSubclass:(Class)subclass overridesSelector:(SEL)selector {
    Class superClass = class_getSuperclass(subclass);
    
    BOOL isMethodOverridden = NO;
    
    while (superClass != Nil) {
        isMethodOverridden = [superClass instancesRespondToSelector:selector] && ([subclass instanceMethodForSelector:selector] != [superClass instanceMethodForSelector:selector]);
        
        if (isMethodOverridden) {
            break;
        }
        
        superClass = [superClass superclass];
    }
    
    return isMethodOverridden;
}
```

示例代码见WCObjectTool.m



### （4）运行时创建类

runtime.h中提供运行时创建类的API，主要分为三个步骤

* 创建class以及它的metaClass，`objc_allocateClassPair()`
* 添加方法和实例变量等
* 注册class到运行时环境，`objc_registerClassPair()`

示例代码，见WCObjCRuntimeTool



## 3、常见Runtime问题

主要列举Objective-C Runtime中遇到的特殊情况以及Crash问题。



### （1）dealloc中创建weak self变量导致Crash[^2]

在dealloc方法或者该方法执行过程中，创建self的weak变量会导致crash，如下

```objective-c
- (void)dealloc {
    __weak typeof(self) weak_self = self; // CRASH
    NSLog(@"%@", weak_self);
}
```

示例代码，见**CreateWeakSelfInDeallocViewController**



dealloc中创建weak self变量，导致Crash，同时控制台出现下面提示。

```shell
objc[49305]: Cannot form weak reference to instance (0x600000e0c340) of class MyModel. It is possible that this object was over-released, or is in the process of deallocation.
(lldb) bt
* thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGABRT
    frame #0: 0x0000000108129016 libsystem_kernel.dylib`__abort_with_payload + 10
    frame #1: 0x00000001081245db libsystem_kernel.dylib`abort_with_payload_wrapper_internal + 82
    frame #2: 0x0000000108124589 libsystem_kernel.dylib`abort_with_reason + 22
    frame #3: 0x0000000105ab2589 libobjc.A.dylib`_objc_fatalv(unsigned long long, unsigned long long, char const*, __va_list_tag*) + 108
    frame #4: 0x0000000105ab24b2 libobjc.A.dylib`_objc_fatal(char const*, ...) + 127
    frame #5: 0x0000000105ac45cb libobjc.A.dylib`weak_register_no_lock + 288
    frame #6: 0x0000000105ac4f8a libobjc.A.dylib`objc_initWeak + 297
  * frame #7: 0x00000001051d9121 HelloObjCRuntimeCrash`-[MyModel dealloc](self=0x0000600000e0c340, _cmd="dealloc") at CreateWeakSelfInDeallocViewController.m:16:25
  ...
```

提示信息"Cannot form weak reference to instance..."在**weak_register_no_lock**方法中，可以查看weak_register_no_lock的[源码](<https://github.com/opensource-apple/objc4/blob/master/runtime/objc-weak.mm#L377>)。



### （2）获取weak变量返回nil[^3]

​      在ARC中获取weak变量是通过特定的C函数完成的，一般是**objc_loadWeakRetained**或者**objc_loadWeak**函数。可以设置符号断点objc_loadWeakRetained，查看获取weak变量的调用栈。例如

```shell
(lldb) bt
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 7.1
    frame #0: 0x0000000100f66203 libobjc.A.dylib`objc_loadWeakRetained
  * frame #1: 0x00000001006471b3 HelloObjCRuntime`__15-[MyModel init]_block_invoke(.block_descriptor=0x00006000022a8bd0) at ObtainWeakVariableViewController.m:25:40
    frame #2: 0x0000000100647355 HelloObjCRuntime`-[MyModel dealloc](self=0x0000600002c9ad20, _cmd="dealloc") at ObtainWeakVariableViewController.m:42:5
    frame #3: 0x0000000100f6672c libobjc.A.dylib`objc_object::sidetable_release(bool) + 202
    frame #4: 0x00000001006475a4 HelloObjCRuntime`-[ObtainWeakVariableViewController viewDidLoad](self=0x00007f8011912c40, _cmd="viewDidLoad") at ObtainWeakVariableViewController.m:55:1
   ...
```



[官方文档](<http://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-runtime-objc-loadweakretained>)指出，在对象**完成释放**或者**已经开始释放**时，通过objc_loadWeakRetained方法返回的是nil。

> **id objc_loadWeakRetained(id \*object)**
>
> If object is registered as a __weak object, and the last value stored into object has not > yet been deallocated or begun deallocation, retains that value and returns it. Otherwise > returns null.



值得注意的是，Xcode的UI调试器显示是weak变量，并没有通过objc_loadWeakRetained方法获取。所以，Xcode显示的变量值和NSLog输出不一致，如下

![](images/weak变量返回nil.png)



测试代码，如下

```objective-c
- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"123";
        
        __weak typeof(self) weak_self = self;
        _cleanUpBlock = ^{
            __strong typeof(weak_self) strong_self = weak_self;
            NSString *localName = weak_self.name;
            
            if (weak_self) NSLog(@"weak_self is not nil");
            else NSLog(@"weak_self is nil");
            
            if (strong_self) NSLog(@"strong_self is not nil");
            else NSLog(@"strong_self is nil");
            
            if (localName) NSLog(@"localName is not nil");
            else NSLog(@"localName is nil");
        };
    }
    return self;
}

- (void)dealloc {
    _cleanUpBlock();
}
```

示例代码见**ObtainWeakVariableViewController**







## References

[^1]:http://stackoverflow.com/questions/5756605/ios-get-pointer-from-nsstring-containing-address
[^2]:<https://www.jianshu.com/p/841f60876180>
[^3]:<https://stackoverflow.com/questions/16122347/weak-property-is-set-to-nil-in-dealloc-but-propertys-ivar-is-not-nil>

[^4]:[http://clang.llvm.org/docs/AutomaticReferenceCounting.html#self](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#self)

[^5]: [http://clang.llvm.org/docs/AutomaticReferenceCounting.html#semantics-of-init](http://clang.llvm.org/docs/AutomaticReferenceCounting.html#semantics-of-init)



