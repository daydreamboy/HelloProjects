# Array

[TOC]

## 1、NSMutableArray

NSMutableArray提供两种API用于移除某个对象，

* `removeObject:`，通过`isEqual:`方法比较来确定移除的对象

* `removeObjectIdenticalTo:`，通过比较对象的指针地址来确定移除的对象。举个例子[^1]，如下

  ```objective-c
  [arrayM removeObjectIdenticalTo:[NSNull null]];
  ```



## 2、常见问题

### (1) NSMutableArray属性设置为copy

当NSMutableArray属性设置为copy时，执行setter方法，实际调用NSMutableArray的copy生成NSArray对象。当该对象调用mutable系列方法（例如addObject方法），就会出现方法找不到的问题[^2]。

举个例子，如下

```objective-c
@interface Tests_NSMutableArray : XCTestCase
@property (nonatomic, copy) NSMutableArray *maybeNotAMutableArray;
@end

@implementation Tests_NSMutableArray
- (void)test_issue_copy_property {
    // WARNING: _maybeNotAMutableArray become immutable after setter (copy)
    self.maybeNotAMutableArray = [NSMutableArray array];
    
    XCTAssertThrowsSpecificNamed([self.maybeNotAMutableArray addObject:@""], NSException, @"NSInvalidArgumentException");
}
@end
```









## References

[^1]:https://stackoverflow.com/a/17282811

[^2]:https://www.jianshu.com/p/5cb9e4b8732b

