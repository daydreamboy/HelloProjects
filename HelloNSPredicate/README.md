## HelloNSPredicate

[TOC]

---

### 1、什么是NSPredicate[^1]

NSPredicate是逻辑条件的定义，用于约束CoreData的fetch操作或者内存中数据的过滤。

官方文档描述，如下

> A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.



NSPredicate主要提供`+[NSPredicate predicateWithFormat:]`等方法，用于创建NSPredicate对象。集合类（**NSArray**/**NSMutableArray**、**NSSet**/**NSMutableSet**等）和**CoreData**的**NSFetchRequest**类有相应的API需要NSPredicate作为参数完成特定操作。例如NSArray的`-[NSArray(NSPredicateSupport) filteredArrayUsingPredicate:]`方法。



有几点需要说明的

* 集合类的元素不一定是系统类，也可以是自定义类的实例。
* 除了NSPredicate类，还有它的一些子类（**NSCompoundPredicate**、**NSComparisonPredicate**）完成特定的功能



### 2、创建NSPredicate[^2]

一般有三种方式，可以创建NSPredicate对象[^1]

* 使用format string创建
* 直接使用NSExpression和NSPredicate及子类，代码创建
* 使用带模板的format string创建



#### （1）使用format string创建

​        format string是NSPredicate类的一些方法（e.g.  `+[NSPredicate predicateWithFormat:]`）的参数，是字符串类型，而且有一定语法约定。

​        format string允许的内容，除了内置的语法关键字之外，还有下面几类：

* 字符串常量（String Contants）
* 变量（Variables）
* 通配符（Wildcards）
* 布尔值（Boolean values）
* 动态属性名（%@和%K）



##### 1. 字符串常量（String Contants）

format string中必须用**双引号**（"）或者**单引号**（'）来表示字符串常量，而且匹配的引号必须是相同类型的。

举个例子，如下

```objective-c
predicate = [NSPredicate predicateWithFormat:@"lastName LIKE \"Smith\""];
```

当format string中有**%@**时，会自动加上双引号。例如





##### 2. 变量（Variables）





#### （2）直接使用NSExpression和NSPredicate





#### （3）使用带模板的format string创建





### 3、format string语法关键字[^3]

format string中允许内置的保留关键字（Reserved Keys），如下



#### （1）格式化符号



#### （2）算术比较符号



#### （3）布尔值符号（Boolean Value Predicates）



#### （4）复合符号（Compound）



#### （5）字符串比较符号

​           字符串比较，默认是**case and diacritic sensitive**，如果不区分，则分别用**c**和**d**来表示。例如`firstName BEGINSWITH[cd] $FIRST_NAME`。



| 保留字              | 含义 | 示例 | 备注 |
| ------------------- | ---- | ---- | ---- |
| **BEGINSWITH**      |      |      |      |
| **CONTAINS**        |      |      |      |
| **ENDSWITH**        |      |      |      |
| **LIKE**            |      |      |      |
| **MATCHES**         |      |      |      |
| **UTI-CONFORMS-TO** |      |      |      |
| **UTI-EQUALS**      |      |      |      |







#### （6）聚合符号（Aggregate）



#### （7）标识符（Identifiers）



#### （8）字面符号（Literals）



## 附录



### 1、format string语法Reserved Words





## References

[^1]: https://nshipster.com/nspredicate/ 

[^2]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html 

[^3]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-SW1 



