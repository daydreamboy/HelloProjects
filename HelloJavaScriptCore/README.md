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



### （3）undefined值

​       JSValue可以封装JavaScript中的*undefined*，在某些情况会产出有undefined值的JSValue对象。使用JSValue的**isUndefined**属性可以判断该值是不是undefined。

举个例子，如下

```objective-c
JSValue *result;
JSContext *context = [[JSContext alloc] init];

// Case 1
result = [context evaluateScript:@"var a = 'hello'"]; // execute code
XCTAssertTrue(result.isUndefined);
XCTAssertEqualObjects([result toString], @"undefined");
XCTAssertEqualObjects([context[@"a"] toString], @"hello");

// Case 2
result = [context evaluateScript:@"b = 'hello'"]; // get value
XCTAssertFalse(result.isUndefined);
XCTAssertEqualObjects([result toString], @"hello");
XCTAssertEqualObjects([context[@"b"] toString], @"hello");

// Case 3
result = [context evaluateScript:@"b"]; // get value
XCTAssertFalse(result.isUndefined);
XCTAssertEqualObjects([result toString], @"hello");
XCTAssertEqualObjects([context[@"b"] toString], @"hello");
```

示例代码见**Tests_JSValue.m**

​       值得注意的是，`-[JSContext evaluateScript:]`方法执行JavaScript代码时，如果JavaScript代码是函数调用或者变量，是可以通过该方法返回的JSValue对象拿到JavaScript环境中的值，例如上面的Case 2和Case 3。当然，如果JavaScript代码是执行语句，则该方法返回的是undefined的JSValue对象，例如上面的Case 1。



## 4、JavaScript和native之间通信



### （1）native从JavaScript环境中获取数据

native从JavaScript环境中获取值，目前有两种方式

* 通过JSContext对象的下标访问方式获取JSValue对象
* 通过`-[JSContext evaluateScript:]`方法返回的JSValue对象



### （2）native将数据传递到JavaScript环境中

#### a. block注入方式

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

上面这种方式，相当于把block注入到JavaScript环境中。如果需要将类以及它的方法注入到JavaScript环境中，就需要使用*JSExport*协议。



注意

> 上面注入的block不能在引用外面的JSValue，以免导致循环引用。如果需要，可以在block中使用`[JSContext currentContext]`获取JavaScript环境中的值



#### b. JSExport

​       JSExport是一个协议，自定义的类实现该协议，JavaScriptCore可以自动将该类的属性、实例方法以及类方法导入到JavaScript环境中。

​      一般来说，自定义类不需要把所有方法都导入到JavaScript环境中，因此自定义类可以遵循JSExport的子协议，将需要暴露给JavaScript的方法放在该子协议中。

举个例子

```objective-c
@class Person;

@protocol PersonJSExports <JSExport>
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger ageToday;
@property (nonatomic, assign) NSInteger birthYear;

- (NSString *)getFullName;
+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
@end
```

子协议PersonJSExports继承自JSExport，它声明所有需要暴露给JavaScript的属性、实例方法以及类方法。



自定义的Person类实现PersonJSExports协议，如下

```objective-c
@interface Person : NSObject <PersonJSExports>
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger ageToday;
@property (nonatomic, assign) NSInteger birthYear;
@end

@implementation Person

- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    Person *person = [[Person alloc] init];
    person.firstName = firstName;
    person.lastName = lastName;
    return person;
}

@end
```

 

​        最后将Person类注入到JavaScript环境中，当执行`context[@"Person"] = [Person class]`后，JavaScript环境中JavaScript代码能访问协议PersonJSExports所声明的方法和属性。

```objective-c
JSContext *context = [[JSContext alloc] init];
context[@"Person"] = [Person class];
```



JavaScript代码中访问JSExport导出的类以及方法，示例如下

```javascript
// 使用Person类的类方法
var person = Person.createWithFirstNameLastName(data[i].first, data[i].last);
// 使用birthYear属性的setter方法
person.birthYear = data[i].year;
// new关键字，根据参数个数自动匹配native的initXXX方法
var point = new MyPoint(1, 2);
// 使用Point类的实例方法
point.description();
```

示例代码见**Tests_JSExport.m**



注意

> Objective-C方法转成JavaScript代码中的函数，都按照下面规则进行转换
>
> * 方法中的`:`都被去掉
> * 方法中`:`后面任意的小写字母都变成大写字母



##### JSExportAs宏

JSExport.h中提供了*JSExportAs*宏，它可以重新命名暴露给JavaScript的方法名。

举个例子，如下

```objective-c
JSExportAs(makeMyPointWithXY, + (MyPoint *)makePoint2WithX:(double)x y:(double)y);
// Note: the aboved JSExportAs preprocessed as the followings lines
/*
@optional
+ (MyPoint *)makePoint2WithX:(double)x y:(double)y __JS_EXPORT_AS__makeMyPointWithXY:(id)argument;
@required
+ (MyPoint *)makePoint2WithX:(double)x y:(double)y;
 */
```

​        JavaScript代码可以使用makeMyPointWithXY函数，而不是makePoint2WithXY函数，而makePoint2WithXY函数在JavaScript环境中也没有定义。



说明

> 实际上，JSExportAs宏定义两个方法，一个optional，一个required，optional方法用标记哪个native方法被重命名为什么方法，JavaScriptCore内部应该会对该optional方法的方法签名做解析。



注意，官方文档指出`JSExportAs`仅适用于方法签名带一个及一个以上参数的方法[^2]。

> The `JSExportAs` macro may only be applied to a selector that takes one or more arguments.



##### 共享对象

​      通过JSExport方式注入到context的native对象，是native和JavaScript共享的对象。不管在native侧，还是JavaScript侧，修改该对象都会影响另一侧[^3]。

举个例子

```objective-c
JSContext *context = [[JSContext alloc] init];
JSValue *pointValue;

MyPoint *point = [MyPoint new];

// native side set initial value
point.x = 1;
context[@"point"] = point;
pointValue = context[@"point"];
NSLog(@"point: %@", point);
NSLog(@"pointValue: %@", pointValue);

// native side change value
point.x = 2;
NSLog(@"point: %@", point);
NSLog(@"pointValue: %@", pointValue);

// JavaScript side change value
[context evaluateScript:@"point.x = 3;"];
NSLog(@"point: %@", point);
NSLog(@"pointValue: %@", pointValue);
```

这里的pointValue和point都指向同一个对象，在native或者JavaScript中修改该对象，都影响另一侧。



注意(TODO)：

> 1. Each JavaScript value is also associated (indirectly via the [`context`](dash-apple-api://load?request_key=hcqUnxSEQa#dash_1451518) property) with a specific [`JSVirtualMachine`](dash-apple-api://load?topic_id=1451743&language=occ) object representing the underlying set of execution resources for its context. You can pass `JSValue` instances only to methods on `JSValue` and [`JSContext`](dash-apple-api://load?topic_id=1451359&language=occ) instances hosted by the same virtual machine—attempting to pass a value to a different virtual machine raises an Objective-C exception.



## References

[^1]:https://nshipster.com/javascriptcore/

[^2]:https://developer.apple.com/documentation/javascriptcore/jsexport?language=objc
[^3]:https://www.bignerdranch.com/blog/javascriptcore-and-ios-7/

