# Objective-C Runtime
[TOC]

## 1、NSObject



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



## References

[^1]:http://stackoverflow.com/questions/5756605/ios-get-pointer-from-nsstring-containing-address