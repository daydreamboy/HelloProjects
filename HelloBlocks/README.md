# Blocks

[TOC]

## 1、Block用法[^1]

​        Objective 2.0引入了Block变量，这个和C中的函数指针差不多。如果了解C的函数指针，对理解Block的使用有一定帮助。 



### （1）声明block变量

举个例子

```objective-c
void (^simpleBlock)(void); // Very similar with void (*simpleBlock)(void) which is in C
```

显然，块变量类似C中的函数指针，即simpleBlock的返回值为void，参数为void。 



### （2）定义block

举个例子

```objective-c
^{
    NSLog(@"This is a block");
}
```



### （3）block变量赋值

举个例子

```objective-c
simpleBlock = ^{
    NSLog(@"This is a block");
}
```



### （4）声明并定义block变量

举个例子

```objective-c
void (^simpleBlock)(void) = ^{
    NSLog(@"This is a block");
}
```



### （5）block变量调用

block变量后跟着*函数调用符*，即一对括号，借用C++中术语，就可以执行block中的代码。

举个例子

```objective-c
simpleBlock(); // Execute code in simpleBlock block
```





举个简单的例子，如下 

```objective-c
#import <Foundation/Foundation.h>
 
int main(int argc, const char * argv[])
{
    @autoreleasepool {
         
        // Define a block variable
        double (^multiplyTwoValues)(double, double);
         
        // Fully specify the block with return type and parameters
        multiplyTwoValues = ^ double (double firstValue, double secondValue) {
            return firstValue * secondValue;
        };
         
        // Ok, without return type
        multiplyTwoValues = ^ (double firstValue, double secondValue) {
            return firstValue * secondValue;
        };
 
        // Use block variable
        double result = multiplyTwoValues(1.0, 2.0);
        NSLog(@"%f", result);
    }
    return 0;
}
```



Block的作用域： 

（1）可以使用在它之前定义的变量，没有加`__block`修饰的，是只读的，在block不能修改该变量； 

（2）加上`__block`的变量，是Block和外围作用域共享的变量，因此可以随时修改，而且在Block回调时使用块变量最新的值； 

（3）Block中声明的变量，在外围作用域中是不能访问的。 



举个例子，如下 

```objective-c
#import <Foundation/Foundation.h>
 
void testFunc() {
    int a = 42;
    __block int c = 32;
     
    void (^testBlock)(void) = ^{
        NSLog(@"a: %d", a); // 42
        NSLog(@"c: %d", c); // 12
        // Compilation Error: undefined variable b, but b is defined below
        //NSLog(@"b: %d", b);
         
        // Compilation Error: a is readonly, cannot change in block
        //a = 100;
        c = 120; // Ok, c is a __block var like a var in block
         
        int d __attribute__ ((unused)) = 200;
    };
     
    a = 55; // Assign new value to a, but don't change value in block
    c = 12; // Ok, __block variable change always reflects in block
     
    int b __attribute__((unused)) = 24; // Suppress waring of unused variable
     
    testBlock();
    NSLog(@"new c: %d", c);
    //NSLog(@"%d", d); // Error, don't know d in block
}
 
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        testFunc();
    }
    return 0;
}
```




再举一个例子，如下 

```objective-c
#import <Foundation/Foundation.h>
 
typedef void (^BoringBlock)(void);
 
int main(int argc, const char * argv[])
{
    // ---------------------------------------------
    // non-block variable in blocks
    int val1 = 23;
    BoringBlock block1 = ^{ NSLog(@"%d", val1); };
    val1 = 42;
    BoringBlock block2 = ^{ NSLog(@"%d", val1); };
    val1 = 17;
    BoringBlock block3 = ^{ NSLog(@"%d", val1); };
     
    block1(); // 23
    block2(); // 42
    block3(); // 17
     
    // ---------------------------------------------
    // __block variable in blocks
    __block int val2 = 23;
    block1 = ^{ NSLog(@"%d", val2); };
    val2 = 42;
    block2 = ^{ NSLog(@"%d", val2); };
    val2 = 17;
    block3 = ^{ NSLog(@"%d", val2); };
     
    block1(); // 17
    block2(); // 17
    block3(); // 17
     
    return 0;
} // main
```



​       可以看出普通变量，在块中是只读的，因此可能在编译时就将块中的只读变量进行值替换，而块变量(_block var)则总是在运行时读取，因此在块被执行时才去内存中去读那个块变量的值。 



Block变量作为函数的形参，可以实现回调函数。C中没有函数重载，但是可以通过传递不同函数的函数指针实现这个功能。类似地，Block用于函数回调，也是因为可以将同一类型的Block变量作为实参传递给函数，供该函数调用。

举个例子，如下 

```objective-c
#import <Foundation/Foundation.h>
  
// Usually block as the last parameter
void testCallback(double a, double b, void (^callback)(double, double)) {
    // Execute the block
    callback(a, b);
}
  
// Define a new type for void (^)(double, double) to shorten the parameter type
typedef void (^CALLBACK)(double, double);
// Ok, use the CALLBACK type
void testCallbackWithType(double a, double b, CALLBACK callback)
{
    callback(a, b);
}
  
int main(int argc, const char * argv[])
{
    @autoreleasepool {
          
        double a = 4.0, b = 2.0;
          
        // Define a block variable and initialize it
        void (^multiply)(double, double) = ^ (double a, double b) {
            NSLog(@"product: %f", a * b);
        };
          
        // Suppress warning of unused variable
        void (^divide)(double, double) __unused = ^ (double a, double b) {
            NSLog(@"quotient: %f", a / b);
        };
          
        testCallback(a, b, multiply); // Ok, pass block variable
        testCallback(a, b, ^ (double a, double b) {
            NSLog(@"quotient: %f", a / b);
        }); // Ok, pass a block directly
          
        // Ok, declaration of block variable is much simpler
        CALLBACK add = ^ (double a, double b) {
            NSLog(@"sum: %f", a + b);
        };
        testCallbackWithType(a, b, add);
    }
    return 0;
}
```



​     Block类型不仅可以用于形参，也可以用于返回值类型。一个复杂的Block变量定义，如下 

注意

> Block中可以修改全局变量，而不用指定__block修改符，这不同于前面提到的函数中局部变量加上__block修饰符。 



```objective-c
#import <Foundation/Foundation.h>
 
// Must define global vars before using them
int a = 10, b = 2, c = 3;
int result;
 
// Define a block variable named complexBlock
// Parameter: a block type: void (^)(void)
// Return type: a block type: void (^)(void)
void (^(^complexBlock)(void (^)(void)))(void) = ^ (void (^aBlock)(void)) {
    aBlock();
     
    return ^{
        result = result - c; // Ok, change global var even though it's not a __block var
    };
};
 
 
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        void (^add)(void) = ^{
            result = a + b; // Ok, change result, it's NOT a __block var
        };
         
        // Pass a block and return a block
        void (^subtract)(void) = complexBlock(add);
        subtract();
        NSLog(@"result: %i", result);
    }
    return 0;
}
```

Block语法还可以定义Block属性，用法和一般属性一样使用点操作符（一定调用了setter和getter方法）。 

在Block属性的定义中，引用了self，一般是想调用其他实例方法，这样很容易造成强引用循环，self指向的对象不能释放。简单分析下，block属性也是一个block实例变量，定义它的块时，如果引用了self，相当于self对象自引用（形象比喻是一个环）。如果self想释放对象时，但是self.blockProperty还有这个对象的引用（block变量需要存储self指针以及其他使用到的变量），因此不能释放，反过来也是一样。 



下面这个例子中，调用assignProperty方法产生了强引用循环，weakRef指向的对象不能释放。 

```objective-c
#import <Foundation/Foundation.h>
 
@interface Person : NSObject
@property (copy) void (^blockProperty)(void); // Ok, block var can also be a property
- (void)assignProperty; // Cause strong reference circulation
- (void)assignPropertySafely; // Solve strong reference circulation
- (void)doSomething;
@end

@implementation Person
- (void)assignProperty
{
    self.blockProperty = ^{
        [self doSomething]; // Strong reference circulation
    };
}
- (void)assignPropertySafely
{
    Person * __weak weakSelf = self; // Use weak reference to avoid reference circulation
    self.blockProperty = ^{
        [weakSelf doSomething];
    };
}
- (void)doSomething
{
    NSLog(@"Do some thing");
}
@end
 
int main(int argc, const char * argv[])
{
    // Define a weak ref to test if aPerson object is deallocated
    // But if the ref is strong and still holds aPerson object,
    // and @autoreleasepool will NOT release the aPerson
    Person * __weak weakRef;
     
    @autoreleasepool {
        Person *aPerson = [[Person alloc] init];
        // Try this unsafe method, "Memory leaked" will be printed
        //[aPerson assignProperty];
        [aPerson assignPropertySafely];
        aPerson.blockProperty();
         
        weakRef = aPerson; // Ok, assign to weak ref will NOT increase ref count
    }
    if (weakRef != nil) { // If aPerson NOT deallocated
        NSLog(@"Memory leaked");
        weakRef.blockProperty();
    }
    if (weakRef == nil) { // If aPerson deallocated
        NSLog(@"aPerson deallocated");
    }
     
    return 0;
}
```





## 2、Block类型

在Xcode中debug时，会遇到下面三种类型的block[^2]：

<\_\_NSGlobalBlock\_\_: 0x112283240> 

<\_\_NSMallocBlock\_\_: 0x7fc4f4822190> 

<\_\_NSStackBlock\_\_: 0x7fff5e1c87e8> 



| Block类型    | ARC下满足条件                                                | MRC下满足条件                                                |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Global Block | block满足下面条件之一，属于global block<br/>* block没有capture任何变量，只使用block中定义的变量或者block的参数<br/>* block没有capture本地变量（包括self），但是允许capture全局变量（static或者non-static）<br/>注意：block带参数，并不是capture变量的情况。 | block满足下面条件之一，属于global block<br/>* block没有capture任何变量，只使用block中定义的变量或者block的参数 |
| Malloc Block | block满足下面条件之一，属于malloc block<br/>* block有capture本地变量（包括self等）<br/>* block中使用`__block`变量 | block满足下面条件之一，属于malloc block<br/>* 对stack block使用copy方法 |
| Stack Block  | 目前ARC下不存在有stack block                                 | block满足下面条件之一，属于stack block<br/>* block有capture本地变量（包括self等）<br/>* block中使用`__block`变量 |



注意：

> MRC下将stack block传给ARC，block会立即释放，会导致EXC_BAD_ACCESS。 









## 3、weak strong dance

​       为了变量循环引用问题，ReactiveCocoa提供一对@weakify/@strongify宏，用于解决该问题。具体见[EXTScope.h](https://github.com/ReactiveCocoa/ReactiveObjC/blob/master/ReactiveObjC/extobjc/EXTScope.h#L83)。

​        简书[这篇文章](https://www.jianshu.com/p/9e18f28bf28d)，较详细分析了这对宏，这里不赘述实现。重点讲下将weak变量变成strong变量的必要性。weak变量指向的对象释放时，会变nil。如果block执行过程中，引用的weak变量变成nil，则逻辑上会有一定的不确定性，因此推荐做法，在block起始地方，将weak变量变成strong变量，保证block后面执行过程中，持有的对象不会被释放。当然，也有另一种方式，在block中发现持有对象是nil，则退出block执行。

​        为了测试在block执行过程中weak变量是否会变成nil的情况，写了下面测试例子。

```objective-c
- (void)test_1_always_use_weak_object {
    self.dictM = [NSMutableDictionary dictionary];
    
    MyObject *object = [MyObject new];
    self.dictM[@"object"] = object;
    
    __weak typeof(object) weak_object = object;
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"1. %@ (%p)", weak_object, [NSThread currentThread]);
        
        [NSThread sleepForTimeInterval:5];
        
        NSLog(@"2. %@ (%p)", weak_object, [NSThread currentThread]); // Maybe nil
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 100; i++) {
            [NSThread detachNewThreadWithBlock:^{
                self.dictM[@"object"] = nil;
                NSLog(@"set nil (%p %d)", [NSThread currentThread], (int)i);
            }];
        }
    });
}
```

> 示例代码，见**WeakStrongDanceViewController**



## 4、Block定义的返回值类型是可选

Block定义时，[官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Blocks/Articles/bxDeclaringCreating.html)指出，返回值类型是可选的

> If you don’t explicitly declare the return value of a block expression, it can be automatically inferred from the contents of the block. If the return type is inferred and the parameter list is `void`, then you can omit the `(void)` parameter list as well. If or when multiple return statements are present, they must exactly match (using casting if necessary).

根据上面描述总结一下

* 没有指定返回值类型，编译器会自动推断返回值类型
* 当有多个return语句时，最好指定返回值类型。没有指定返回值类型，可能不能正确自动推断，导致编译出错
* 当参数列表为void，可以去掉void描述



举个例子

```objective-c
float (^oneFrom)(float);

// Note: OK, only one return statement
oneFrom = ^(float aFloat) {
    float result = aFloat - 1.0;
    return result;
};

// Note: OK, specify return type is best
oneFrom = ^float(float aFloat) {
    float result = aFloat - 1.0;
    return result;
};

// Compiler Error: can't deduce the return type
oneFrom = ^(float aFloat) {
    float result = aFloat - 1.0;
    if (aFloat > 3) {
        return aFloat - 3.0; // Note: this is double
    }
    return result;
};

// OK
oneFrom = ^float(float aFloat) {
    float result = aFloat - 1.0;
    if (aFloat > 3) {
        return aFloat - 3.0; // Note: this is double
    }
    return result;
};
```

示例代码见**Tests_Block.m**



## 5、使用Block常见问题

### （1）block为nil时调用会crash

```objective-c
__weak MyObject *weak_object;
{
    MyObject *object;
    object = [MyObject new];
    object.block = ^{
        NSLog(@"object");
    };
    weak_object = object;
}

weak_object.block(); // Crash
```

安全方式：调用block，判断block是否为nil。



## References

[^1]: ProgrammingWithObjectiveC.pdf, Work with Blocks (P104)
[^2]: https://www.cocoawithlove.com/2009/10/how-blocks-are-implemented-and.html



