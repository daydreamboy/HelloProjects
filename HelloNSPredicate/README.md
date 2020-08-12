# HelloNSPredicate

[TOC]

---



## 1、什么是NSPredicate[^1]

NSPredicate是逻辑条件的定义，用于约束CoreData的fetch操作或者内存中数据的过滤。

官方文档描述，如下

> A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.



NSPredicate主要提供`+[NSPredicate predicateWithFormat:]`等方法，用于创建NSPredicate对象。集合类（**NSArray**/**NSMutableArray**、**NSSet**/**NSMutableSet**等）和**CoreData**的**NSFetchRequest**类有相应的API需要NSPredicate作为参数完成特定操作。例如NSArray的`-[NSArray(NSPredicateSupport) filteredArrayUsingPredicate:]`方法。



有几点需要说明的

* 集合类的元素不一定是系统类，也可以是自定义类的实例。
* 除了NSPredicate类，还有它的一些子类（**NSCompoundPredicate**、**NSComparisonPredicate**）完成特定的功能



## 2、创建NSPredicate[^2]

一般有三种方式，可以创建NSPredicate对象[^1]

* 使用format string创建（Creating a Predicate Using a Format String）
* 直接使用NSExpression和NSPredicate及子类，代码创建
* 使用带模板的format string创建



### （1）使用format string创建

​        format string是NSPredicate类的一些方法（e.g.  `+[NSPredicate predicateWithFormat:]`）的参数，是字符串类型，而且有一定语法约定。

​        format string允许的内容，除了内置的语法关键字之外，还有下面几类：

* 属性名（Attribute）

* 字符串常量（String Contants）
* 动态属性名 (`%@`和`%K`)（Dynamic Property Name）
* 通配符（Wildcards）
* 布尔值常量（Boolean Values）
* 变量（Variables）



#### 1. 属性名（Attribute）

format string中的**属性名**，类似某个对象的属性。

举个例子，如下

```objective-c
Person *person = [Person new];
person.lastName = @"Smith";
predicate = [NSPredicate predicateWithFormat:@"lastName like 'Smith'"];
trueOrFalse = [predicate evaluateWithObject:person];
XCTAssertTrue(trueOrFalse);

person.lastName = @"Smmith";
predicate = [NSPredicate predicateWithFormat:@"lastName like 'Smith'"];
trueOrFalse = [predicate evaluateWithObject:person];
XCTAssertFalse(trueOrFalse);
```

这里"lastName like 'Smith'"中的lastName就是person对象的属性。而`like`则是语法关键字



说明

>官方文档描述中，format string syntax中属性名使用的是attribute，而不是property。



#### 2. 字符串常量（String Contants）

format string中必须用**双引号**（"）或者**单引号**（'）来表示**字符串常量**，而且匹配的引号必须是相同类型的。

举个例子，如下

```objective-c
predicate = [NSPredicate predicateWithFormat:@"lastName LIKE \"Smith\""];
```



当format string中有**%@**时，会自动加上双引号。例如

```objective-c
[NSPredicate predicateWithFormat:@"lastName LIKE %@", @"Smith"];
```

这里不需要把%@加上双引号或者单引号。



说明：

> 使用单引号字符串常量时，NSPredicate的predicateFormat方法，输出总是双引号字符串常量。



#### 3. 动态属性名（Dynamic Property Name）

​        format string支持占位替换，有两种占位替换方式：`%@`和`%K`。format string语法中称为**动态属性名**（Dynamic Property Name）



##### 字符串替换（`%@`）

使用`%@`做替换，`%@`被替换成带双引号的字符串。

举个例子，如下

```objective-c
NSString *attributeName = @"firstName";
NSString *attributeValue = @"Adam";

predicate = [NSPredicate predicateWithFormat:@"%@ like %@", attributeName, attributeValue];
XCTAssertEqualObjects(predicate.predicateFormat, @"\"firstName\" LIKE \"Adam\"");
```

使用NSPredicate的predicateFormat方法，可以获取替换后format string。



##### 字面替换（`%K`）

不同于`%@`，`%K`仅字面替换，替换的内容不会自动加上双引号。

举个例子，如下

```objective-c
NSString *attributeName = @"firstName";
NSString *attributeValue = @"Adam";

predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
XCTAssertEqualObjects(predicate.predicateFormat, @"firstName LIKE \"Adam\"");
```

这里替换后的firstName并没有加上双引号，因此它是一个属性名（attribute）。



注意：

> 1. `%@`和`%K`被单引号或双引号引起来后，就当成普通字符串，不会执行替换操作。
> 2. `%K`的K必须是大写，否则NSPredicate调用predicateWithFormat:方法会抛出异常。



#### 4. 通配符（Wildcards）

字符串常量中支持使用两种通配符，`*`和`?`。在字符串匹配时，可以使用通配符。



##### `*`匹配0个或者多个字符

举个例子，如下

```objective-c
evaluatedString = @"prefixxxxxxsuffix";

predicate = [NSPredicate predicateWithFormat:@"SELF like[c] 'prefix*suffix'"];
trueOrFalse = [predicate evaluateWithObject:evaluatedString];
XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix*suffix\"");
XCTAssertTrue(trueOrFalse);
```



注意：

> `*`作为通配符时，必须在字符串常量中。例如formatString为`@"SELF like[c] %@*%@"`，则认为两个动态属性名进行乘法元素。如果%@是字符串，执行evaluateWithObject:方法会抛出异常。正确写法是，`@"SELF like[c] %@", sustitutedString`，sustitutedString包含需要通配符`*`的字符串。



##### `?`匹配1个字符

举个例子，如下

```objective-c
evaluatedString1 = @"prefixxsuffix";
evaluatedString2 = @"prefixsuffix";

predicate = [NSPredicate predicateWithFormat:@"SELF like[c] 'prefix?suffix'"];
XCTAssertEqualObjects(predicate.predicateFormat, @"SELF LIKE[c] \"prefix?suffix\"");

trueOrFalse = [predicate evaluateWithObject:evaluatedString1];
XCTAssertTrue(trueOrFalse);

trueOrFalse = [predicate evaluateWithObject:evaluatedString2];
XCTAssertFalse(trueOrFalse);
```



#### 5. 布尔值常量（Boolean Values）

​       format string支持使用布尔值常量，即`YES`/`NO`、`TRUE`/`FALSE`。而它们的小写形式也是支持的，即`yes`/`no`、`true`/`false`。

举个例子，如下

```objective-c
Person *person = [Person new];
person.isMale = YES;

predicate = [NSPredicate predicateWithFormat:@"isMale == YES"];
XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
trueOrFalse = [predicate evaluateWithObject:person];
XCTAssertTrue(trueOrFalse);
```

​       布尔值常量在NSPredicate的predicateFormat中，都被转成1和0。因此，除了使用布尔值常量，直接使用1和0，也是支持的。



​       NSNumber包装的布尔值，可以使用`%@`的方式使用，例如

```objective-c
Person *person = [Person new];
boolValue = YES;
person.isMale = YES;

predicate = [NSPredicate predicateWithFormat:@"isMale == %@", @(boolValue)];
XCTAssertEqualObjects(predicate.predicateFormat, @"isMale == 1");
trueOrFalse = [predicate evaluateWithObject:person];
XCTAssertTrue(trueOrFalse);
```



#### 6. 变量（Variables）







### （2）直接使用NSExpression和NSPredicate





### （3）使用带模板的format string创建





## 3、format string语法关键字[^3]

format string中允许内置的保留关键字（Reserved Keys），如下



### （1）格式化符号



### （2）算术比较符号



### （3）布尔值符号（Boolean Value Predicates）

| 关键字             | 含义        | format string示例                                    |
| ------------------ | ----------- | ---------------------------------------------------- |
| **TRUEPREDICATE**  | 总是true值  | @"TRUEPREDICATE"<br/>@"(1 < 0) \|\| TRUEPREDICATE"   |
| **FALSEPREDICATE** | 总是false值 | @"FALSEPREDICATE"<br/>@"(1 < 0) \|\| FALSEPREDICATE" |



### （4）复合符号（Compound Predicates）

| 关键字           | 含义   | format string示例                                 |
| ---------------- | ------ | ------------------------------------------------- |
| **AND**, **&&**  | 逻辑与 | @"(1 < 0) && (1 > 0)"<br/>@"(1 < 0) AND (1 > 0)"  |
| **OR**, **\|\|** | 逻辑或 | @"(1 < 0) \|\| (1 > 0)"<br/>@"(1 < 0) OR (1 > 0)" |
| **NOT**, **!**   | 逻辑非 | @"!(1 < 0)"<br/>@"NOT(1 < 0)"                     |





### （5）字符串比较符号

​           字符串比较，默认是**case and diacritic sensitive**，如果不区分，则分别用**c**和**d**来表示。例如`firstName BEGINSWITH[cd] $FIRST_NAME`。



| 关键字              | 含义 | 示例 | 备注 |
| ------------------- | ---- | ---- | ---- |
| **BEGINSWITH**      |      |      |      |
| **CONTAINS**        |      |      |      |
| **ENDSWITH**        |      |      |      |
| **LIKE**            |      |      |      |
| **MATCHES**         |      |      |      |
| **UTI-CONFORMS-TO** |      |      |      |
| **UTI-EQUALS**      |      |      |      |







### （6）聚合符号（Aggregate）



| 关键字            | 含义                    | 示例                                    | 备注 |
| ----------------- | ----------------------- | --------------------------------------- | ---- |
| **ANY**, **SOME** |                         |                                         |      |
| **ALL**           |                         |                                         |      |
| **NONE**          |                         |                                         |      |
| **IN**            | 和SQL中IN操作符是一样的 | @"name IN { 'Ben', 'Melissa', 'Nick' }" |      |
| array[index]      |                         |                                         |      |
| array[**FIRST**]  |                         |                                         |      |
| array[**LAST**]   |                         |                                         |      |
| array[**SIZE**]   |                         |                                         |      |



#### IN

IN和SQL中IN操作符是一样的，判断的条件是左边的属性必须在右边的集合中。示意代码，如下

```objective-c
NSPredicate *inPredicate = [NSPredicate predicateWithFormat: @"attribute IN %@", aCollection];
```

aCollection可以是NSArray、NSSet或NSDictionary实例（包括子类实例），以及对应的mutable实例





### （7）标识符（Identifiers）



### （8）字面符号（Literals）



## 附录



### 1、format string语法Reserved Words





## References

[^1]: https://nshipster.com/nspredicate/ 

[^2]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html 

[^3]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-SW1 



