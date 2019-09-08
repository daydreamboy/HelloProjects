# HelloNSObject

[TOC]

## 1、关于NSObject

### （1）+load方法

`+load`方法是NSObject的类方法，调用顺序依次为

* 父类中load方法

* 子类中load方法

* 父类的分类中load方法

* 子类的分类中load方法

* C constructor函数（使用`__attribute__((constructor))`标记的C函数）

* 全局C++对象的构造函数

  > Math m = Math();
  >
  > Math *m2 = new Math();

* main函数调用

示例代码见**OrderOfCallLoadMethodInNSObject**



### （2）+initialize方法

`+initialize`方法是NSObject的类方法，当类第一次发送任意类消息时，会触发该方法，有且仅有一次触发。同时，如果存在继承关系，总是先触发父类的initialize方法，然后自身类的initialize方法。

* 子类可以重新实现initialize方法，并通过super调用父类的initialize方法，但是不显示调用initialize方法，父类的initialize方法依然会被调用

* 防止父类的initialize方法被调用多次，可以采用下面的方法

  > ```objective-c
  > + (void)initialize {
  >       if (self == [ClassName self]) {
  >         // ... do the initialization ...
  >       }
  > }
  > ```

* 和`+load`方法不同，分类中实现的initialize方法会覆盖主类

示例代码见**OrderOfCallInitializeMethodInNSObject**和**InitializeMethodInCategory**



## 2、Object Subscripting[^1]

​        Xcode 4.4开始支持对象下标访问方式，即除了NSMutableDictionary和NSMutableArray之外，任意自定义类都可以使用`[]`来访问。

​        自定义类通过实现特定的方法，能支持索引下标和键下标。

### （1）索引下标的实现方法

```objective-c
@interface IndexedSubscriptingObject<__covariant ObjectType> : NSObject
- (nullable ObjectType)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(nullable ObjectType)object atIndexedSubscript:(NSUInteger)index;
@end
```



### （2）键下标的实现方法

```objective-c
@interface KeyedSubscriptingObject<__covariant KeyType, __covariant ObjectType> : NSObject
- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;
@end
```



示例代码，参考WCOrderedDictionary



## 3、运行时Runtime



### （1）Swizzle方法

​       Objective-C的运行时（Runtime），提供替换某个方法的实现的功能，也称为Swizzle方法。这里仅讨论Swizzle Objective-C方法。

​       Objective-C方法，定义为Method类型，代码中的实例方法和类方法，在运行时都对应这个Method，每个Method对应一个selector和IMP，可以通过selector执行Method，而实际上是执行IMP。IMP是一个C函数指针。

​       代码中的Objective-C方法，编译器已经编译好IMP，可以等价看成Objective-C方法就是IMP。Swizzle方法，实际上是替换现有方法的IMP。

​       替换IMP，目前有三种方法

* 用block作为swizzled IMP去替换。主要用到`imp_implementationWithBlock`函数，将block转成IMP，然后替换现有方法的IMP
* 用Objective-C分类方法作为swizzled IMP去替换。一般实现某个类的分类方法，然后将这个分类方法的IMP替换原来方法的IMP
* 用C函数作为swizzled IMP去替换。这个过程和用Objective-C分类方法去替换差不多，只不过是直接用C函数作为IMP去替换原来方法的IMP

> 上面三种方式，分别见SwizzleMethodByBlockViewController、SwizzleMethodByCategoryMethodViewController、SwizzleMethodByCFunctionViewController









## References

[^1]:<https://nshipster.com/object-subscripting/>