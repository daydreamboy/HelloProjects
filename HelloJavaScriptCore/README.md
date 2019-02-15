# JavaScriptCore

[TOC]

## 1、介绍JavaScriptCore

​      OS X Mavericks和iOS 7引入JavaScriptCore framework（后简称**JavaScriptCore**），它用Objective-C封装了WebKit JavaScript引擎[^1]。

​      JavaScriptCore提供执行JavaScript代码的能力，也允许放入native对象到JavaScript环境中。



## 2、JSContext

​       **JSContext**是执行JavaScript代码的运行环境，可以访问JavaScript代码中定义或计算出来的值，也可以让native的对象（object）、方法（method）、函数（function）被JavaScript代码访问。



### （1）下标访问

​      JSContext实例允许字符串下标访问，例如

```objective-c
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:@"var names = ['Grace', 'Ada', 'Margaret']"];
JSValue *names = context[@"names"];
```



### （2）异常处理

JSContext提供`exceptionHandler`属性用于捕获执行JavaScript时的异常。

举个例子，如下

```objective-c
JSContext *context = [[JSContext alloc] init];
context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
    NSLog(@"JS Error: %@", exception); // JS Error: SyntaxError: Unexpected end of script
};

[context evaluateScript:@"function multiply(value1, value2) { return value1 * value2 "];
```



## 3、JSValue

​      **JSValue**的实例是JavaScript中值的引用。使用JSValue可以在JavaScript代码和native代码之间传递数据，JSValue可以封装native代码中自定义类的对象，或者JavaScript函数但实现放在native代码中。

​     每个**JSValue**实例来自一个**JSContext**实例，实际上JSValue实例强引用JSContext实例（JSValue有**context**属性），这意味着JSValue被持有，对应的JSContext也被持有。



### （1）封箱类型

JSValue可以封装的类型，如下

| JavaScript Type | JSValue method                | Objective-C Type | Swift Type              |
| --------------- | ----------------------------- | ---------------- | ----------------------- |
| string          | toString                      | NSString         | String!                 |
| boolean         | toBool                        | BOOL             | Bool                    |
| number          | toNumber                      | NSNumber         | NSNumber!               |
| number          | toDouble                      | double           | Double                  |
| number          | toInt32                       | int32_t          | Int32                   |
| number          | toUInt32                      | uint32_t         | UInt32                  |
| Date            | toDate                        | NSDate           | NSDate!                 |
| Array           | toArray                       | NSArray          | [AnyObject]!            |
| Object          | toDictionary                  | NSDictionary     | [NSObject : AnyObject]! |
| Object          | toObject<br/>toObjectOfClass: | *custom type*    | *custom type*           |



除了上面的类型，JSValue还可以封装JavaScript函数。例如

```objective-c
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:@"var triple = function(value) { return value * 3 }"];
JSValue *tripleFunction = context[@"triple"];
JSValue *result = [tripleFunction callWithArguments:@[@5]];
XCTAssertTrue([result toInt32] == 15);
```

说明

> 1. 通过`-[JSValue callWithArguments:]`方法可以执行对一个JavaScript函数的调用
> 2. JSValue实例方法返回新的JSValue实例，这个新实例也属于同一个context。例如这里产生的result对象也持有context对象



### （2）下标访问



JSValue实例允许字符串或者数字下标访问，例如

```objective-c
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:@"var list=[1, 2, 3]"];
[context evaluateScript:@"var map={'key': 'value'}"];

// Case 1: number as subscript
JSValue *list = context[@"list"];
JSValue *element1 = list[0];

// Case 2: string as subscript
JSValue *map = context[@"map"];
JSValue *value = map[@"key"];
```



## 4、JavaScript和native之间通信



### （1）native从JavaScript环境中获取数据

native从JavaScript环境中获取值，可以通过JSContext和JSValue的下标访问方式



### （2）native将数据传递到JavaScript环境中

native将数据传递给JavaScript环境，可以使用JSContext下标访问方式。例如

```objective-c
JSContext *context = [[JSContext alloc] init];
context[@"simplifyString"] = ^(NSString *input) {
    NSMutableString *mutableString = [input mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformStripCombiningMarks, NO);
    return mutableString;
};

JSValue *result = [context evaluateScript:@"simplifyString('안녕하새요!')"];
XCTAssertEqualObjects([result toString], @"annyeonghasaeyo!");
```





注意：

> 1. Each JavaScript value is also associated (indirectly via the [`context`](dash-apple-api://load?request_key=hcqUnxSEQa#dash_1451518) property) with a specific [`JSVirtualMachine`](dash-apple-api://load?topic_id=1451743&language=occ) object representing the underlying set of execution resources for its context. You can pass `JSValue` instances only to methods on `JSValue` and [`JSContext`](dash-apple-api://load?topic_id=1451359&language=occ) instances hosted by the same virtual machine—attempting to pass a value to a different virtual machine raises an Objective-C exception.



## References

[^1]:https://nshipster.com/javascriptcore/



