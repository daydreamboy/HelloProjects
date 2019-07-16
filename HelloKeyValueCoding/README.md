# KeyValueCoding

[TOC]



## 1、集合操作符（Collection Operators）[^1]

​       集合操作符是以`@`开头，后面跟着特定关键词的字符串，用于在KVC（KeyValueCoding）的`valueForKeyPath:`方法中。

​       完整的keyPath结构，分为三个部分：Left key path、Collection operator、Right key path，如下

![](images/keypath.jpg)

集合操作符（Collection Operator）根据行为，分为下面三种操作符

* Aggregation Operator（聚合操作符），将一系列对象做聚合操作，得到单个对象。例如`@count`
* Array Operator（数组操作符），返回NSArray对象。一般是原对象集合的子集。
* Nesting Operator（嵌套操作符），适用于集合嵌套集合的情况。



### Aggregation Operators



| 操作符 | 含义     | 返回值   | 示例                                                  |
| ------ | -------- | -------- | ----------------------------------------------------- |
| @avg   | 取平均数 | NSNumber | `[collectionObject valueForKeyPath:@"@avg.property"]` |
| @count | 取个数   | NSNumber | `[collectionObject valueForKeyPath:@"@count"]`        |
| @max   | 取最大数 | id       | `[collectionObject valueForKeyPath:@"@max.property"]` |
| @min   | 取最小数 | id       | `[collectionObject valueForKeyPath:@"@min.property"]` |
| @sum   | 取总数   | NSNumber | `[collectionObject valueForKeyPath:@"@sum.property"]` |



### Array Operators



| 操作符                  | 含义 | 示例 |
| ----------------------- | ---- | ---- |
| @distinctUnionOfObjects |      |      |
| @unionOfObjects         |      |      |



### Nesting Operators



| 操作符                 | 含义 | 示例 |
| :--------------------- | :--- | :--- |
| @distinctUnionOfArrays |      |      |
| @unionOfArrays         |      |      |
| @distinctUnionOfSets   |      |      |









## References

[^1]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html#//apple_ref/doc/uid/20002176-SW9 Apple KVC 文档