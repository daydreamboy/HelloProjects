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



说明

> exception是JSValue对象，可以使用exception[@"line"]、exception[@"column"]、exception[@"stack"])，获取行号、列号以及JS的堆栈[^7]



### （3）内置函数、内置对象的支持

JavaScript内置函数或对象，一般在window对象中可以找到。例如decodeURIComponent函数。对于JavaScript内置函数或对象，JSContext有些支持，有些不支持。不支持的函数，则需要自己实现。

下面列出两个表，表示对JavaScript内置函数的支持情况



#### a. 支持的JavaScript内置函数或对象

| 函数               | 说明 |
| ------------------ | ---- |
| decodeURIComponent |      |
| encodeURIComponent |      |





#### b. 不支持的JavaScript内置函数或对象

| 函数         | 说明 |
| ------------ | ---- |
| alert        |      |
| clearTimeout |      |
| console对象  |      |
| setInterval  |      |
| setTimout    |      |



> 示例代码，见JSTestList



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



另外，JSValue还可以封装JavaScript闭包，作为回调函数传给native[^8]。例如

```objective-c
context[@"calculate"] = ^(JSValue *param1, JSValue *param2, JSValue *param3, JSValue *callback) {
    if ([param1.toString isEqualToString:@"+"]) {
        int sum = param2.toInt32 + param3.toInt32;
        [callback callWithArguments:@[@(sum)]];
    }
};
[context evaluateScript:@"var result; calculate('+', 3, 4, function(res){ \
 result = res;\
 })();"];
result = context[@"result"];
XCTAssertTrue([result toInt32] == 7);
```

注意：callback参数不能是具体的block类型，必须是JSValue类型，否则context执行时会抛出异常。



说明

> 1. 通过`-[JSValue callWithArguments:]`方法可以执行对一个JavaScript函数的调用
> 2. JSValue实例方法返回新的JSValue实例，这个新实例也属于同一个context。例如这里产生的result对象也持有context对象



### （2）下标访问



JSValue实例和JSContext实例一样，允许使用字符串或者数字下标访问，例如

```objective-c
JSContext *context = [[JSContext alloc] init];
[context evaluateScript:@"var list=[1, 2, 3]"];
[context evaluateScript:@"var map={'key': 'value'}"];

// Case 1: number as subscript
JSValue *list = context[@"list"];
list[3] = @(4);
JSValue *element1 = list[0];

// Case 2: string as subscript
JSValue *map = context[@"map"];
JSValue *value = map[@"key"];
map[@"key2"] = @"value2";
value = map[@"key2"];
```

说明

> 使用字符串或者数字下标访问，包括读取和赋值



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



#### JSValue的undefined值转换Native其他类型值

​         在JSExport导出方法时，建议**参数类型都指定为JSValue**，而不是具体的Native类型（CGFloat、NSString等）。

​        因为JS调用函数，可以不确定参数个数，如果没有传，默认将undefined值传到Native方法的参数。但是JSValue的undefined值转native有很多需要注意的地方，如下

* undefined值，toString不是nil，是undefined
* undefined值，toDouble是nan
* undefined值，toNumber不是nil

* undefined值，toDate不是nil，而是-5877520-03-03 -596:-31:-23 +0000
* ……

测试代码，如下

```objective-c
XCTAssertTrue(result.isUndefined);

XCTAssertNil([result toObject]); // nil
XCTAssertNil([result toObjectOfClass:[NSString class]]); // nil

BOOL b = [result toBool];
XCTAssertTrue(b == NO);

double d = [result toDouble];
XCTAssertTrue(isnan(d));

int32_t i32 = [result toInt32];
XCTAssertTrue(i32 == 0);

uint32_t ui32 = [result toUInt32];
XCTAssertTrue(ui32 == 0);

NSNumber *n = [result toNumber];
XCTAssertNotNil(n);
XCTAssertEqualObjects([n stringValue], @"nan");

NSString *s = [result toString];
XCTAssertNotNil(s);
XCTAssertEqualObjects(s, @"undefined");

NSDate *date = [result toDate];
XCTAssertNotNil(date);
XCTAssertEqualObjects([date description], @"-5877520-03-03 -596:-31:-23 +0000");

XCTAssertNil([result toArray]);
XCTAssertNil([result toDictionary]);

CGPoint p = [result toPoint];
XCTAssertTrue(isnan(p.x));
XCTAssertTrue(isnan(p.y));

NSRange range = [result toRange];
NSUInteger location = range.location;
NSUInteger length = range.length;
XCTAssertTrue(location == (unsigned long)LONG_MAX + 1LL); // 9223372036854775808
XCTAssertTrue(length == (unsigned long)LONG_MAX + 1LL); // 9223372036854775808

CGRect rect = [result toRect];
XCTAssertTrue(isnan(rect.origin.x));
XCTAssertTrue(isnan(rect.origin.y));
XCTAssertTrue(isnan(rect.size.width));
XCTAssertTrue(isnan(rect.size.height));

CGSize size = [result toSize];
XCTAssertTrue(isnan(size.width));
XCTAssertTrue(isnan(size.height));
```



### （4）定义Property

​      JavaScript对象的属性（Propery），可以通过下标方式直接赋值，也可以通过`-[JSValue defineProperty:descriptor:]`方法来细粒度定义属性。这个方法类似JavaScript中的`Object.defineProperty()`方法。

defineProperty:descriptor:方法，签名如下

```
- (void)defineProperty:(JSValueProperty)property descriptor:(id)descriptor;
```

* property参数，类型是JSValueProperty。JSValueProperty实际是NSString或者id（iOS 13+）的别名。

* descriptor参数，类型是id，可以传入词典。词典的key，有如下几种

  ```c
  JSPropertyDescriptorWritableKey // 属性是否可写，默认是NO，即属性只读
  JSPropertyDescriptorEnumerableKey // 该属性是否可以通过所属对象的for-in枚举出来，默认是NO
  JSPropertyDescriptorConfigurableKey // 该属性是否可以重新定义，默认是NO
  JSPropertyDescriptorValueKey // 属性的初始值，默认值是undefined
  JSPropertyDescriptorGetKey
  JSPropertyDescriptorSetKey
  ```



将下面的JavaScript使用`Object.defineProperty()`方法，换成对应`-[JSValue defineProperty:descriptor:]`方法，如下

```javascript
const object1 = {};

Object.defineProperty(object1, 'property1', {
  value: 42,
  writable: false
});

object1.property1 = 77;
// throws an error in strict mode

console.log(object1.property1);
// expected output: 42
```

改成Objective-C，如下

```objective-c
JSContext *context = [[JSContext alloc] init];
JSValueProperty propertyName;
JSValue *property;

propertyName = @"property1";
[context.globalObject defineProperty:propertyName descriptor:@{
    JSPropertyDescriptorValueKey: @(42),
}];
property = [context.globalObject valueForProperty:propertyName];

context.globalObject[@"property1"] = @(77);

NSLog(@"%@", context.globalObject[@"property1"]); // expected output: 42
```



defineProperty:descriptor:方法，允许多次被调用，并且重复定义相同的属性，descriptor有不同的属性key。

注意

> 如果第一次调用，属性key没有设置JSPropertyDescriptorWritableKey或者JSPropertyDescriptorConfigurableKey，则后面调用defineProperty:descriptor:方法设置相同的属性，会产生JS Error。
>
> 举个例子，如下
>
> ```objective-c
> - (void)test_defineProperty_descriptor_issue {
>     JSContext *context = [[JSContext alloc] init];
>     
>     // defineProperty for same property
>     [context.globalObject defineProperty:@"property1" descriptor:@{
>         JSPropertyDescriptorValueKey: @(1),
>     }];
>     
>     // JS Error: TypeError: Attempting to change value of a readonly property.
>     [context.globalObject defineProperty:@"property1" descriptor:@{
>         JSPropertyDescriptorValueKey: @(2),
>     }];
> }
> ```
>
> 解决方法：在第一次定义属性时，设置它的属性key为JSPropertyDescriptorWritableKey或者JSPropertyDescriptorConfigurableKey，表示该属性可写，或者可以重新配置。



## 4、JavaScript和native之间通信



### （1）native从JavaScript环境中获取数据

native从JavaScript环境中获取值，目前有两种方式

* 通过JSContext对象的下标访问方式获取JSValue对象
* 通过`-[JSContext evaluateScript:]`方法返回的JSValue对象



### （2）native注入callback，JavaScript调用callback

native将数据（block、类等）注入到JavaScript环境中，这里泛指为JavaScript callback或JS callback。JavaScript环境中，再使用这些callback（函数、类）触发native方法的调用。这样完成JavaScript到native通信。



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



​       block注入方式，相当于把block变成JavaScript侧的函数。如果JavaScript侧的函数，需要带可变参数列表，可以在block中通过`[JSContext currentArguments]`，该方法返回`NSArray<JSValue *> *`。

举个例子

```objective-c
JSContext *context = [[JSContext alloc] init];
context[@"changeColor"] = ^{
    NSArray<JSValue *> *args = [JSContext currentArguments];
    if (args.count == 3) {
        int32_t r = [args[0] toInt32];
        int32_t g = [args[1] toInt32];
        int32_t b = [args[2] toInt32];

        NSLog(@"args: %@", args);
        XCTAssertTrue(r == 255);
        XCTAssertTrue(g == 1);
        XCTAssertTrue(b == 2);
    }
    else if (args.count == 4) {
        int32_t r = [args[0] toInt32];
        int32_t g = [args[1] toInt32];
        int32_t b = [args[2] toInt32];
        int32_t a = [args[3] toInt32];

        NSLog(@"args: %@", args);
        XCTAssertTrue(r == 255);
        XCTAssertTrue(g == 1);
        XCTAssertTrue(b == 2);
        XCTAssertTrue(a == 255);
    }
    else {
        NSLog(@"paramters of changeColor function is error");
    }
};

[context evaluateScript:@"changeColor(255, 1, 2);"];
[context evaluateScript:@"changeColor(255, 1, 2, 255);"];
```

可见block注入方式，在native侧不需要声明参数，JavaScript侧函数支持参数传入不同个数。

示例代码见**Tests_JSContext.m**



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



##### 构造函数

**使用new创建对象必须要有init方法**

​       JavaScript使用new创建对象，会调用该类的构造函数，需要Native端的JSExport导出init方法。JSExport导出的类，注入到JSContext中，默认没有JS端的构造函数。当JS代码使用new关键词创建实例时，会发生异常。

举个例子，如下

```objective-c
MyCycle_noInitMethod *c;
JSValue *value;
JSContext *context = [[JSContext alloc] init];
context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
    [WCJSCTool printExceptionValue:exception]; // TypeError: MyCycle_noInitMethodConstructor is not a constructor (evaluating 'new MyCycle_noInitMethod()')
};
context[@"MyCycle_noInitMethod"] = [MyCycle_noInitMethod class];

// Case: `new` keyword will call JSExport init or initXXX:..: method
[context evaluateScript:@"var c = new MyCycle_noInitMethod();"];
value = context[@"c"];
XCTAssertTrue(value.isUndefined);

c = [value toObjectOfClass:[MyCycle_noInitMethod class]];
XCTAssertNil(c);
```

​       上面MyCycle_noInitMethod的JSExport协议没有导出init方法，则new MyCycle_noInitMethod()会抛出JS异常，对应的变量c也是undefined。



**JSExport导出init方法只能有一个**

JSExport导出init方法只能有一个，如果JSExport导出多个init方法，则运行时报错如下

```text
ERROR: Class MyCycle_twoMoreInitMethod exported more than one init family method via JSExport. Class MyCycle_twoMoreInitMethod will not have a callable JavaScript constructor function.
```

JS调用构造函数抛出异常，导致赋值变量为undefined。

```
TypeError: MyCycle_twoMoreInitMethodConstructor is not a constructor (evaluating 'new MyCycle_twoMoreInitMethod()')
```



**JSExport导出正确init方法**

确定JS的构造函数的参数个数和顺序，实现参数个数最多的init方法，同时参数类型一定指定为JSValue。

举个例子，MyCycle的构造函数有三个参数，所有参数都是可选的。

```objective-c
@protocol MyCycleJSExport <JSExport>
- (instancetype)initWithRadius:(JSValue *)radius x:(JSValue *)x y:(JSValue *)y;
@end

- (instancetype)initWithRadius:(JSValue *)radius x:(JSValue *)x y:(JSValue *)y {
    self = [super init];
    if (self) {
        _radius = radius.isUndefined ? 0 : [radius toDouble];
        _x = x.isUndefined ? 0 : [x toDouble];
        _y = y.isUndefined ? 0 : [y toDouble];
    }
    return self;
}
```

通过JSValue的isUndefined属性判断，JS调用构造函数是否传入对应的参数。

JS代码，如下

```javascript
context[@"MyCycle"] = [MyCycle class];

[context evaluateScript:@"var c1 = new MyCycle();"];
[context evaluateScript:@"var c2 = new MyCycle(2);"];
[context evaluateScript:@"var c3 = new MyCycle(2, 1);"];
[context evaluateScript:@"var c4 = new MyCycle(2, 1, 3);"];
```



## 5、WebView中JavaScript和native交互

WebView（UIWebView和WKWebView）都提供执行JavaScript代码的接口，如下

* UIWebView，`-[UIWebView stringByEvaluatingJavaScriptFromString]`
* WKWebView，`-[WKWebView evaluateJavaScript:completionHandler:]`

​       上面方式属于native从JavaScript环境中获取数据，只能单向通信，有一定局限性。

​       实际上，WebView内部使用JavaScriptCore，但没有将相关对象（JSContext、JSVirtualMachine等）暴露出来。如果要完成双向通信，可以参考下面的方式。



### （1）UIWebView获取JSContext[^4]

```objective-c
JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
```

​       在`-[UIWebViewDelegate webViewDidFinishLoad:]`中，通过KVC，可以获取UIWebView的JSContext，并将native代码（block、JSExport导出的类等）注入到JavaScript环境中。

示例代码见**UseJSContextOfUIWebViewViewController**，代码参考简书[这篇文章](https://www.jianshu.com/p/4db513ed2c1a)



注意

>  为确保页面加载完成，在`-[UIWebViewDelegate webViewDidFinishLoad:]`中，才执行注入[^5]。



### （2）WKWebView使用WKUserScript

​        WKWebView和UIWebView不一样，不能使用KVC方式获取JSContext[^6]。但是WebKit.framework提供*WKUserScript*用于封装JavaScript代码。如下

```objective-c
WKUserContentController *userContentController = [WKUserContentController new];

NSString *JSSourceCode = @"window.webkit.messageHandlers.welcome.postMessage({msg: 'Welcome to use WKWebView'});";
WKUserScript *JSCode = [[WKUserScript alloc] initWithSource:JSSourceCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
[userContentController addUserScript:JSCode];

WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
configuration.userContentController = userContentController;

WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
```

示例代码见**JSCallNativeInWKWebViewViewController**



## 6、JavaScriptCore兼容性问题

iOS 9版本上JavaScriptCore对很多JavaScript特性不支持

| 特性     | 说明 |
| -------- | ---- |
| 箭头函数 |      |
| let变量  |      |
| Promise  |      |







## References

[^1]:https://nshipster.com/javascriptcore/

[^2]:https://developer.apple.com/documentation/javascriptcore/jsexport?language=objc
[^3]:https://www.bignerdranch.com/blog/javascriptcore-and-ios-7/
[^4]:https://stackoverflow.com/a/21719420
[^5]:https://stackoverflow.com/questions/21714365/uiwebview-javascript-losing-reference-to-ios-jscontext-namespace-object
[^6]:https://stackoverflow.com/questions/25792131/how-to-get-jscontext-from-wkwebview
[^7]:https://stackoverflow.com/questions/34273540/ios-javascriptcore-exception-detailed-stacktrace-info

[^8]:https://stackoverflow.com/a/41201799



