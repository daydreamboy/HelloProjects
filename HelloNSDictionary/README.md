# NSDictionary

[TOC]

## 1、CFDictionary和CFMutableDictionary

​       CFDictionary是CoreFoundation中集合类型，对应NSDictionary。另外，它的派生类型CFMutableDictionary对应的是NSMutableDictionary。

​       CFDictionary能创建静态词典，而CFMutableDictionary能创建动态词典。CFDictionary的key可以是任意C类型，如果需要序列化到XML格式，则必须是CFString类型。

> Keys for a CFDictionary may be of any C type, however note that if you want to convert a CFPropertyList to XML, any dictionary’s keys must be CFString objects.

CFDictionary的key和value，都是被CFDictionary对象持有的，添加key和value时不会执行copy操作。

> When adding key-value pairs to a dictionary, the keys and values are not copied—they are retained so they are not invalidated before the dictionary is deallocated.



### （1）自定义CFMutableDictionary的callback

​        CFMutableDictionary的`CFDictionaryCreateMutable`函数，用于创建CFMutableDictionaryRef对象。它的签名，如下

```objective-c
CFMutableDictionaryRef CFDictionaryCreateMutable(CFAllocatorRef allocator, CFIndex capacity, const CFDictionaryKeyCallBacks *keyCallBacks, const CFDictionaryValueCallBacks *valueCallBacks)
```

* allocator，一般指定NULL或者kCFAllocatorDefault

* capacity，一般指定0，表示不限制大小，词典大小自动增长

  * 如果指定了大小，当词典大小满了，某些其他函数会出现不可预知的情况，例如CFDictionaryAddValue的文档指出

    > If the dictionary is a fixed-capacity dictionary and it is full before this operation, the behavior is undefined.

  * 大小不能指定是负数

* keyCallBacks，提供指向CFDictionaryKeyCallBacks结构体的指针。CFDictionaryKeyCallBacks的字段，如下

  > ```objective-c
  > typedef struct {
  >     CFIndex				version;
  >     CFDictionaryRetainCallBack		retain;
  >     CFDictionaryReleaseCallBack		release;
  >     CFDictionaryCopyDescriptionCallBack	copyDescription;
  >     CFDictionaryEqualCallBack		equal;
  >     CFDictionaryHashCallBack		hash;
  > } CFDictionaryKeyCallBacks;
  > ```
  >
  > version，一般是0
  >
  > retain，指定key需要retain时的回调函数。如果是NULL，则key不需要retain。
  >
  > release，指定key需要release时的回调函数。如果是NULL，则key不需要release。
  >
  > copyDescription，指定key返回字符串类型的描述。当调用CFCopyDescription函数时，就会调用copyDescription回调。如果NULL，则使用CFDictionaryCopyDescriptionCallBack为默认回调函数。
  >
  > equal，指定比较两个key的回调函数。如果是NULL，则使用CFDictionaryEqualCallBack为默认回调函数，即将两个key的指针作为整型进行比较。
  >
  > hash，指定获取hash值的回调函数，该hash值用于access/add/remove value的函数。如果是NULL，则使用CFDictionaryHashCallBack为默认回调函数，即将key的指针转成整型作为hash值。

* valueCallBacks，提供指向CFDictionaryValueCallBacks结构体的指针。CFDictionaryValueCallBacks的字段，其实和上面的CFDictionaryKeyCallBacks的字段是一样的。



举个使用自定义CFDictionaryKeyCallBacks和CFDictionaryValueCallBacks的例子[^1]，如下

```objective-c
static const void *MyCFDictionaryRetainCallback(CFAllocatorRef allocator, const void *value)
{
    id object = (__bridge id)value;
    return CFRetain((__bridge CFTypeRef)(object));
}

static void MyCFDictionaryReleaseCallback(CFAllocatorRef allocator, const void *value)
{
    id object = (__bridge id)value;
    CFRelease((__bridge CFTypeRef)(object));
}

- (void)test_CFMutableDictionaryRef_with_custom_key_value_callbacks {
    CFMutableDictionaryRef dict;
    NSString *output;
    
    CFDictionaryKeyCallBacks keyCallbacks =
    {
        0,
        MyCFDictionaryRetainCallback,
        MyCFDictionaryReleaseCallback,
        CFCopyDescription,
        CFEqual,
        NULL
    };
    
    CFDictionaryValueCallBacks valueCallbacks =
    {
        0,
        MyCFDictionaryRetainCallback,
        MyCFDictionaryReleaseCallback,
        CFCopyDescription,
        CFEqual
    };
    
    // Note: create dictionary with both key and value retained
    dict = CFDictionaryCreateMutable(NULL, 0, &keyCallbacks, &valueCallbacks);
    CFDictionaryAddValue(dict, CFSTR("key"), CFSTR("value"));
    
    output = CFDictionaryGetValue(dict, (__bridge CFStringRef)@"key");
    
    CFRelease(dict);
    dict = NULL;
    
    XCTAssertEqualObjects(output, @"value");
}
```

示例代码见Tests_CFDictionary.m



### （2）基于非字符串类型key的CFMutableDictionary

​       可以通过配置CFDictionaryKeyCallBacks和CFDictionaryValueCallBacks的retain和release字段来决定是否retain和release的key或value。如果key或value是基本类型，可以将这两个字段传入NULL。另外，还是直接在`CFDictionaryCreateMutable`函数传入NULL[^2]，如下

```objective-c
// Note: key as primitive type, value also as primitive type
CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
// Setting values
CFDictionarySetValue(dict, (void *)5, (void *)10);

output1 = (NSInteger)CFDictionaryGetValue(dict, (void *)5);

CFRelease(dict);
dict = NULL;

XCTAssertTrue(output1 == 10);
```

示例代码见Tests_CFDictionary.m



### （3）CFDictionaryAddValue和CFDictionarySetValue的区别

如果key存在，CFDictionaryAddValue相当于不执行任何操作

如果key存在，CFDictionarySetValue执行替换操作



## 2、实现Fast Enumeration

集合类（NSDictionary、NSArray等）很多实现`NSFastEnumeration`协议，用于forin遍历。

`NSFastEnumeration`协议，声明了一个方法，如下

```objective-c
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable *)buffer count:(NSUInteger)len;
```

forin遍历，实际上是调用了上面这个方法。



mikeash的[这篇文章](https://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html)提供forin语法经过编译器改写后的伪代码，如下

```objective-c
// declare all the local state needed
NSFastEnumerationState state = { 0 };
id stackbuf[16];
BOOL firstLoop = YES;
long mutationsPtrValue;
    
// outer loop
NSUInteger count;
while((count = [collection countByEnumeratingWithState: &state objects: stackbuf count: 16]))
{
    // check for mutation, but only after the first loop
    // (note that I'm not sure whether the real compiler puts this
    // in the inner loop or outer loop, and it could conceivably
    // change from one compiler version to the next)
    if(!firstLoop && mutationsPtrValue != *state.mutationsPtr)
        @throw ..mutation exception...
    firstLoop = NO;
    mutationsPtrValue = *state.mutationsPtr;

    // inner loop over the array returned by the NSFastEnumeration call
    id obj;
    for(NSUInteger index = 0; index < count; index++)
    {
        obj = state.itemsPtr[index];
        // body
    }
}
```



> 这篇[文章](http://blog.leichunfeng.com/blog/2016/06/20/objective-c-fast-enumeration-implementation-principle/)提供使用clang来输出forin之后的代码



​        通过上面的伪代码，可见当`countByEnumeratingWithState:objects:count:`方法返回0时，则退出while循环，因此在while循环退出之前，需要将遍历的数据全部给到while里面的for循环。因此，有两种方式：

* 一次性将全部数据给到state.itemsPtr，while循环遍历2次
* 部分数据给到state.itemsPtr，while循环遍历大于2次



​      Apple官方提供了一个实现Fast Enumeration的[示例代码](https://developer.apple.com/library/archive/samplecode/FastEnumerationSample/Introduction/Intro.html)，提供上面两种方式，来实现`countByEnumeratingWithState:objects:count:`方法。这里不再赘述。



注意：

> 如果实现Fast Enumeration的集合类的backend是NSArray，则可以在`countByEnumeratingWithState:objects:count:`方法中调用NSArray`countByEnumeratingWithState:objects:count:`方法。示例代码，见WCOrderedDictionary









## Reference

[^1]:https://byronlo.wordpress.com/tag/cfmutabledictionary/
[^2]:https://blog.spacemanlabs.com/2011/08/integers-in-your-collections-nsnumbers-not-my-friend/













