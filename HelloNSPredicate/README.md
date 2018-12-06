## HelloNSPredicate

[TOC]

---

### 1、什么是NSPredicate

NSPredicate是逻辑条件的定义，用于约束CoreData的fetch操作或者内存中数据的过滤。

官方文档描述，如下

> A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.



NSPredicate主要提供`+[NSPredicate predicateWithFormat:]`等方法，用于创建NSPredicate对象。集合类（**NSArray**/**NSMutableArray**、**NSSet**/**NSMutableSet**等）和**CoreData**的**NSFetchRequest**类有相应的API需要NSPredicate作为参数完成特定操作。例如NSArray的`-[NSArray(NSPredicateSupport) filteredArrayUsingPredicate:]`方法。



有几点需要说明的

* 集合类的元素不一定是系统类，也可以是自定义类的实例。
* 除了NSPredicate类，还有它的一些子类（**NSCompoundPredicate**、**NSComparisonPredicate**）完成特定的功能



### 2、创建NSPredicate[^2]

一般有三种方式，可以创建NSPredicate对象

* 使用format string创建
* 直接使用NSExpression和NSPredicate及子类，代码创建
* 使用带模板的format string创建



#### （1）使用format string创建

format string是NSPredicate类的一些方法的参数，是字符串类型，而且有一定语法约定。





#### （2）直接使用NSExpression和NSPredicate





#### （3）使用带模板的format string创建





### 3、NSPredicate的format语法[^1]

​      NSPredicate的一些API，都有format参数，它是字符串类型，而且有一定语法约定。归纳下面几类语法特性，如下



#### （1）变量替换

format字符串里面允许**%K**和**%@**占位符





## References

[^1]: https://nshipster.com/nspredicate/ 

[^2]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html 





