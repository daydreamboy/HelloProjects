# Array

[TOC]

## 1、NSMutableArray

NSMutableArray提供两种API用于移除某个对象，

* `removeObject:`，通过`isEqual:`方法比较来确定移除的对象

* `removeObjectIdenticalTo:`，通过比较对象的指针地址来确定移除的对象。举个例子[^1]，如下

  ```objective-c
  [arrayM removeObjectIdenticalTo:[NSNull null]];
  ```





## References

[^1]:https://stackoverflow.com/a/17282811

