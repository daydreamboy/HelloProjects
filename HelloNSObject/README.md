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

`+initialize`方法是NSObject的类方法，当类第一次发送任意类消息时，会触发该方法，有且仅触发依次。同时，如果存在继承关系，先触发父类的initialize方法，然后自身类的initialize方法。

* 子类可以重新initialize方法，并通过super调用父类的initialize方法

* 防止父类的initialize方法被调用多次，可以采用下面的方法

  > ```objective-c
  > + (void)initialize {
  >   if (self == [ClassName self]) {
  >     // ... do the initialization ...
  >   }
  > }
  > ```

