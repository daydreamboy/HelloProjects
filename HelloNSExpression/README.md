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

| Function | Arguments                                             | Returns             | Availability |
| -------- | ----------------------------------------------------- | ------------------- | ------------ |
| average: | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |
| sum:     | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |
| count:   | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |
| min:     | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |
| max:     | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |
| median:  | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |
| mode:    | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSArray<NSNumber *> |              |
| stddev:  | @[[NSExpression expressionForConstantValue:@[@1,@2]]] | NSNumber            |              |



* average，求平均数
* sum，求总和
* count，求个数
* min，求最小值
* max，求最大值
* median，求中位数。排序后，取中间的数，如果两个，则取它们的平均值。
  * 例如1, 2, 4, 7的中位数[^2]是3，即(2 + 4) / 2 = 3。
  * 例如13, 13, 13, 13, 14, 14, 16, 18, 21的中位数[^2]是14。
* mode，求众数。取出现次数最多的数。
  * 例如13, 13, 13, 13, 14, 14, 16, 18, 21的众数[^2]是13。
  * 如果出现次数最多的数有多个，这里mode函数求众数的方式是，按照数组顺序，取第一个。

* stddev，求标准差。



#### （2）Basic Arithmetic

| Function       | Arguments                                                    | Returns  | Availability |
| -------------- | ------------------------------------------------------------ | -------- | ------------ |
| add:to:        | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber |              |
| from:subtract: | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber |              |
| multiply:by:   | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber |              |
| divide:by:     | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber |              |
| modulus:by:    | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber |              |
| abs:           | @[[NSExpression expressionForConstantValue:@(X)]]            | NSNumber |              |



#### （3）Advanced Arithmetic

| Function       | Arguments                                                    | Returns  | Availability |
| -------------- | ------------------------------------------------------------ | -------- | ------------ |
| sqrt:          | @[[NSExpression expressionForConstantValue:@(X)]]            | NSNumber |              |
| log:           | @[[NSExpression expressionForConstantValue:@(X)]]            | NSNumber |              |
| ln:            | @[[NSExpression expressionForConstantValue:@(X)]]            | NSNumber |              |
| raise:toPower: | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber |              |
| exp:           | @[[NSExpression expressionForConstantValue:@(X)]]            | NSNumber |              |



#### （4）Bounding Functions

| Function | Arguments（NSArray<NSExpression *>中的NSExpression含义） | Returns  | Availability |
| -------- | -------------------------------------------------------- | -------- | ------------ |
| ceiling: | @[[NSExpression expressionForConstantValue:@(X)]]        | NSNumber |              |
| trunc:   | @[[NSExpression expressionForConstantValue:@(X)]]        | NSNumber |              |



#### （5）Functions Shadowing `math.h` Functions

| Function | Arguments                                         | Returns  | Availability |
| -------- | ------------------------------------------------- | -------- | ------------ |
| floor:   | @[[NSExpression expressionForConstantValue:@(X)]] | NSNumber |              |



#### （6）Random Functions

| Function | Arguments（NSArray<NSExpression *>中的NSExpression含义） | Returns  | Availability    |
| -------- | -------------------------------------------------------- | -------- | --------------- |
| random   | @[]                                                      | NSNumber |                 |
| random:  | @[[NSExpression expressionForConstantValue:@(X)]]        | NSNumber | iOS 11.4-不支持 |





#### （7）Binary Arithmetic

| Function         | Arguments                                                    | Returns              | Availability |
| ---------------- | ------------------------------------------------------------ | -------------------- | ------------ |
| bitwiseAnd:with: | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber (NSInteger) |              |
| bitwiseOr:with:  | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber (NSInteger) |              |
| bitwiseXor:with: | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber (NSInteger) |              |
| leftshift:by:    | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber (NSInteger) |              |
| rightshift:by:   | @[[NSExpression expressionForConstantValue:@(X)], [NSExpression expressionForConstantValue:@(Y)]] | NSNumber (NSInteger) |              |
| onesComplement:  | @[[NSExpression expressionForConstantValue:@(2)]]            | NSNumber (NSInteger) |              |





#### （8）Date Functions

| Function | Arguments（NSArray<NSExpression *>中的NSExpression含义） | Returns | Availability |
| -------- | -------------------------------------------------------- | ------- | ------------ |
| now      | @[]                                                      | NSDate  |              |

* now，arguments参数可以为nil，防止warning，传入空的数组



#### （9）String Functions

| Function   | Arguments                                           | Returns  | Availability |
| ---------- | --------------------------------------------------- | -------- | ------------ |
| lowercase: | @[[NSExpression expressionForConstantValue:@"ABC"]] | NSString |              |
| uppercase: | @[[NSExpression expressionForConstantValue:@"abc"]] | NSString |              |



#### （10）No-op

| Function | Arguments | Returns | Availability |
| -------- | --------- | ------- | ------------ |
| noindex: |           |         |              |



### 3、使用自定义函数表达式





### 4、方程式计算[^3]

例子





### References

[^1]: https://nshipster.com/nsexpression/ 
[^2]: https://www.purplemath.com/modules/meanmode.htm
[^3]: https://stackoverflow.com/a/19873034
[^4]: https://spin.atomicobject.com/2015/03/24/evaluate-string-expressions-ios-objective-c-swift/