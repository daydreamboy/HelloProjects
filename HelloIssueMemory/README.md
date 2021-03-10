# HelloIssueMemory

[TOC]

## 1、常见内存Crash问题



* 对象over release
* 无效对象release



## 2、常见Crash示例

### （1）NSStackBlock

```objective-c
- (void)test_crash_caused_by_NSStackBlock {
    NSArray *tmp = [self getBlockArray1];
    myBlock block = [tmp[0] copy];
    block();
    // Crash when out of this function
    //
    // NSStackBlock is over release:
    // first time, getBlockArray1 stack frame is cleaned
    // second time, NSArray object is released, so crash here
}

- (id)getBlockArray1 {
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);}, // NSMallocBlock
            ^{NSLog(@"blk1:%d", val);}, // NSStackBlock, which cause the crash
            nil];
}
```

类型：对象over release

分析：NSStackBlock对象被释放两次，第一次是在getBlockArray1返回时，函数堆栈被清理，由于它是stack类型，所以被释放了。第二次是在tmp对象被释放，NSArray内部会清理element时，这时出现crash。



### （2）无效对象

```objective-c
- (void)test_crash_caused_by_invalid_object {
    NSArray *tmp = [self getBlockArray2];
    myBlock block = [tmp[2] copy]; // Crash: EXC_BAD_ACCESS
    block();
}

- (id)getBlockArray2 {
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);}, // NSMallocBlock
            ^{NSLog(@"blk1:%d", val);}, // NSStackBlock
            ^{NSLog(@"blk2:%d", val);}, // id, but invalid object
            nil];
}
```

类型：无效对象release

分析：getBlockArray2返回时，第3个element已经是id类型，但是无法打印对象，可能是对象创建失败。如果再使用这个对象，会出现EXC_BAD_ACCESS。



### （3）block capture autorelease out parameter

​           在ARC下，编译器会将`NSError **`修饰成`(NSError * __autoreleasing *)error`[^1]，当传入out参数时，在某些函数的block中，由于可能存在autoreleasepool，out参数指向的对象可能被释放掉，导致使用out参数访问时出现EXC_BAD_ACCESS。

举个例子，如下

```objective-c
- (void)test {
    NSError *error = nil;
    [self validateDictionary:@{@"key": @"value"} error:&error]; // Crash: EXC_BAD_ACCESS
}

- (void)validateDictionary:(NSDictionary<NSString *, NSString *> *)dict error:(NSError **)error {
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            if (error) { // warning: block captures an autoreleasing out-parameter, which may result in use-after-free bugs
                *error = [NSError errorWithDomain:@"FishDomain" code:0 userInfo:nil];
            }
        }
    }];
}
```



​       正确的方式可以采用临时一个NSError变量来存储block中的NSError对象，然后将这个临时NSError变量赋值给out参数，如下

```objective-c
- (void)fixed_validateDictionary:(NSDictionary<NSString *, NSString *> *)dict error:(NSError **)error {
    __block NSError *strongError = nil;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            strongError = [NSError errorWithDomain:@"FishDomain" code:0 userInfo:nil];
        }
    }];
    if (error) {
        *error = strongError;
    }
}
```





## References

[^1]:http://yulingtianxia.com/blog/2017/07/17/What-s-New-in-LLVM-2017/









