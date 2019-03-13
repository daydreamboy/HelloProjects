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





## References

[^1]:http://stackoverflow.com/questions/5756605/ios-get-pointer-from-nsstring-containing-address