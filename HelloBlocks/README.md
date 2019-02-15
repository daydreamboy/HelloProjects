## HelloBlocks

[TOC]

### 1、weak strong dance

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

示例代码见**WeakStrongDanceViewController**



### 2、Block定义的返回值类型是可选

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



### 3、使用Block常见问题

#### （1）block为nil时调用会crash

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



