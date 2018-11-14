## HelloNSExpression

[TOC]

---

### 1、算术表达式（Numeric Expression）

NSExpression支持算术表达式，如下

* 直接字面常量，例如-5、3.14、100、0x50

* 简单算术符：`+`、`-`、`*`、`/`、`**`、`()`
  * `/`，是整除。如果需要浮点数，需要除数和被除数两者是是浮点数。
  * `**`，是幂运算。例如2**3 = 8
  * `+`、`-`、`*`、`/`、`**`、`()`，都支持十六进制数
  * `()`，允许前面有负号。例如-(1-3)
* 按位运算：`&` 、`|`、`~`、`^`、`<<`、`>>`
  * 十进制仅支持1和0之间的按位运算，但是~0不是1，而是-1
  * `&` 、`|`、`~`、`^`，都支持十六进制数
  * `<<`，按位左移，支持十进制数和十六进制数。例如0x10 >> 1 == 8
  * `>>`，按位右移，支持十进制数和十六进制数。例如0x10 << 1== 32

* 不支持数学的符号，`%` (e.g. 120%)、`==` (e.g. 1== 1)、`=` (e.g. 1= 1)、`!` (e.g. 3!)

例子参考AlgorithmExpressionViewController

```objective-c
NSNumber *number;
    
@try {
    NSExpression *mathExpression = [NSExpression expressionWithFormat:self.textField.text];
    number = [mathExpression expressionValueWithObject:nil context:nil];
}
@catch (NSException *e) {
    // TODO
}
```



### 2、使用预定义函数表达式（Function Expression）

​        NSExpression提供`+[NSExpression expressionForFunction:arguments:]`方法用于创建一个预定义函数表达式，其中第一个参数是函数名（e.g. @"average:"）；第二个参数是NSArray，元素都是NSExpressions实例，而且元素个数可以是一个或者两个。

​       上面NSArray中NSExpressions实例可以使用`+ (NSExpression *)expressionForConstantValue:(id)obj;`创建，其中传入不同的obj类型，创建不同的expression。

​       举个例子，如下

```objective-c
// Case 1
NSArray *numbers = @[ @1, @2, @3, @4, @5 ];

NSExpression *averageExpression = [NSExpression expressionForFunction:@"average:" arguments:@[[NSExpression expressionForConstantValue:numbers]]];

NSNumber *resultOfAverage = [averageExpression expressionValueWithObject:nil context:nil];

// Case 2
NSExpression *sqrtExpression = [NSExpression expressionForFunction:@"sqrt:" arguments:@[[NSExpression expressionForConstantValue:@2]]];

NSNumber *resultOfSqrt = [sqrtExpression expressionValueWithObject:nil context:nil];
```

注意：

* 不同函数名，要求这里的obj是不同的类型。例如`average:`需要obj是一个NSArray<NSNumber *>，而`sqrt:`需要obj是一个NSNumber。

* `- (id)expressionValueWithObject:(id)object context:(NSMutableDictionary *)context;`的作用是，获取表达式的值，其返回值类型是id类型。不同函数表达式用这个方法获取的返回值是不一样的。例如`average:`的返回值是NSNumber，而`max:`的返回值是NSArray<NSNumber *>。



按照NSHipster[^1]的分类，预定义函数，有下面几类

#### （1）Statistics

| Function | Arguments（NSArray<NSExpression *>中的NSExpression含义） | Returns  | Availability |
| -------- | -------------------------------------------------------- | -------- | ------------ |
| average: | NSArrary<NSNumber *>                                     | NSNumber |              |
| sum:     |                                                          |          |              |
| count:   |                                                          |          |              |
| min:     |                                                          |          |              |
| max:     |                                                          |          |              |
| median:  |                                                          |          |              |
| mode:    |                                                          |          |              |
| stddev:  |                                                          |          |              |







[^1]: https://nshipster.com/nsexpression/ 



