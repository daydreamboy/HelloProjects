# Objective-C Runtime
[TOC]

## 1、Runtime介绍





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







