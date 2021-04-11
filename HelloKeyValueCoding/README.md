# KeyValueCoding

[TOC]

## 1、介绍KVC

### （1）KVC的定义

​        KeyValueCoding（KVC）是Objective-C的Runtime提供的能力，通过NSKeyValueCoding“协议”提供的API方法，允许使用name或者key来访问对象的属性或实例变量。满足这种方式的对象，称为key-value coding compliant（后面简称KVC compliant）。



官方描述[^2]，如下

> Key-value coding is a mechanism enabled by the `NSKeyValueCoding` informal protocol that objects adopt to provide indirect access to their properties.



在NSKeyValueCoding.h文件中，声明了NSObject的NSKeyValueCoding分类，系统默认为NSObject实现了KVC机制，因此NSObject以及它的子类都具有KVC compliant。



典型的使用NSKeyValueCoding的API，有下面2个方法，如下

```objective-c
// 获取property的值
- (id)valueForKey:(NSString *)key;
// 设置property的值
- (void)setValue:(id)value forKey:(NSString *)key;
```



KVC的作用有下面几点

* KVC是一些Cocoa技术的基础，例如KVO、Cocoa bindings、Core Data等

* KVC可以动态传参数，某些情况下，可以简化代码



官方描述[^2]，如下

> Key-value coding is a fundamental concept that underlies many other Cocoa technologies, such as key-value observing, Cocoa bindings, Core Data, and AppleScript-ability. Key-value coding can also help to simplify your code in some cases.



### （2）NSKeyValueCoding的API

除了使用key来访问，还可以使用keyPath来访问。因此，NSKeyValueCoding的API可以按照Set/Get和Key/KeyPath组合，有4类API方法，如下

* Get + Key
* Get + KeyPath
* Set + Key
* Set + KeyPath

按照上面的分类，NSKeyValueCoding的API，如下

```objective-c
// 1. Get + Key
// 相当于@property的Getter方法。如果key对应的属性没有初始化，则返回nil
- (id)valueForKey:(NSString *)key;
// 默认实现是keys依次调用valueForKey:，如果value是nil，则用[NSNull null]代替
- (NSDictionary<NSString *,id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys;
// 默认实现是抛出NSUndefinedKeyException异常。子类可以重写该方法
- (id)valueForUndefinedKey:(NSString *)key;
// 返回代理的mutable集合，用于操作to-many关系的属性
- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;
- (NSMutableSet *)mutableSetValueForKey:(NSString *)key;
- (NSMutableOrderedSet *)mutableOrderedSetValueForKey:(NSString *)key;

// 2. Get + KeyPath
- (id)valueForKeyPath:(NSString *)keyPath;
- (NSMutableArray *)mutableArrayValueForKeyPath:(NSString *)keyPath;
- (NSMutableSet *)mutableSetValueForKeyPath:(NSString *)keyPath;
- (NSMutableOrderedSet *)mutableOrderedSetValueForKeyPath:(NSString *)keyPath;

// 3. Set + Key
- (void)setValue:(id)value forKey:(NSString *)key;
// 默认实现是抛出NSUndefinedKeyException异常。子类可以重写该方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
// 默认实现是抛出NSInvalidArgumentException异常。子类可以重写该方法
- (void)setNilValueForKey:(NSString *)key;
// 默认实现是对于keyedValues每个键值对，依次调用setValue:forKey:，如果value是[NSNull null]，则用设置为nil
- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues;

// 4. Set + KeyPath
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
```



有几点值得说明的是

* 带keyPath的方法，内部实现基本都是多次调用带key的方法

* KVC的Set和Get方法，获取的值都是原始对象，不是copy对象。举个例子，如下

  ```objective-c
  id output;
  
  // Case 1: valueForKey: not copy object
  Person *p = [[Person alloc] init];
  Account *basicAccount = [Account new];
  p.basicAccount = basicAccount;
  output = [p valueForKey:@"basicAccount"];
  XCTAssertTrue(output == basicAccount);
  
  // Case 2: setValue:forKey: not copy object
  Account *basicAccount2 = [Account new];
  [p setValue:basicAccount2 forKey:@"basicAccount"];
  XCTAssertTrue(p.basicAccount == basicAccount2);
  ```

* NSKeyValueCoding的API也适用于基本类型（例如int、double、CGSize等），会转成NSNumber或者NSValue对象。
* 对于集合对象调用NSKeyValueCoding的API，实际是对集合中每个元素对象调用对应的方法





### （3）KVC的属性关系

根据KVC compliant对象的属性是简单的值类型（例如NSNumber、NSString、CGSize等）、对象类型（例如自定义的类对象），还是集合对象（例如collection object），可以定义KVC的属性关系[^3]

* attribute关系，简单的值属性关系
* to-one关系，一对一关系，这个属性的key，对应一个对象值
* to-many关系，一对多关系，这个属性的key，对应多个值或对象值

这里的属性关系，指在KVC下，属性和值满足哪种关系。



举个例子，如下

```objective-c
@interface BankAccount : NSObject
@property (nonatomic) NSNumber* currentBalance;              // An attribute
@property (nonatomic) Person* owner;                         // A to-one relation
@property (nonatomic) NSArray< Transaction* >* transactions; // A to-many relation
@end
```

上面三种关系的属性，都可以使用基本的`valueForKey:`和`setValue:forKey:`方法来访问。



值得说明的是，to-many关系的属性，调用NSKeyValueCoding的API，是遍历集合中每个元素，每个元素调用对应的NSKeyValueCoding的API。

举个例子，如下

```objective-c
NSMutableArray *output;

Person *p1 = [[Person alloc] init];
p1.name = @"John";

Person *p2 = [[Person alloc] init];
p2.name = @"Lucy";

NSArray *array = @[p1, p2];

// Case 1: valueForKey on collection object
output = [array valueForKey:@"name"];
XCTAssertTrue([output isKindOfClass:[NSArray class]]);
XCTAssertTrue(output.count == 2);
XCTAssertEqualObjects(output[0], @"John");
XCTAssertEqualObjects(output[1], @"Lucy");
```



#### a. 对collection object的元素增删操作

​        对于to-many关系的属性，如果要修改集合对象的元素个数（增加或删除等），需要使用Get API取出来，然后变成mutable对象，增删它的元素个数，然后再把新的集合对象通过Set API设置到to-many关系的属性上[^4]。

这个过程比较繁琐，而且性能不高。KVC已经提供对应的API来完成这个事情，如下

```objective-c
// 返回NSMutableArray对象
mutableArrayValueForKey: and mutableArrayValueForKeyPath:
// 返回NSMutableSet对象
mutableSetValueForKey: and mutableSetValueForKeyPath:
// 返回NSMutableOrderedSet对象
mutableOrderedSetValueForKey: and mutableOrderedSetValueForKeyPath:
```

上面3个API，会返回一个代理的mutable类型对象，对于该对象进行增删元素操作，就是对to-many关系的属性值进行操作。

注意

> 1. to-many关系的属性，即使声明或者实例变量是immutable对象，仍然可以使用代理mutable对象来进行增删元素操作
>
> 2. 如果to-many关系的属性没有初始化，然后获取代理mutable对象来操作，可能出现异常。
>
>    举个例子，如下
>
>    ```objective-c
>    Person *p = [[Person alloc] init];
>    NSMutableArray *proxyMutableArray;
>        
>    // Case 1: Get proxy mutable collection
>    proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
>    XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
>    
>    // Error: if accounts is nil, output.count will throw exception internally
>    XCTAssertThrowsSpecificNamed(proxyMutableArray.count, NSException, NSInternalInconsistencyException);
>    ```
>
>    这里代理mutable对象proxyMutableArray调用count方法，就会出现NSInternalInconsistencyException异常



举个例子，如下

```objective-c
@interface Person : NSObject
@property (nonatomic, strong) NSMutableArray<Account *> *accounts;
@property (nonatomic, strong) NSArray<Account *> *frozenAccounts;
- (void)addAccount:(Account *)account;
@end

- (void)test {
  Person *p = [[Person alloc] init];
  NSMutableArray *proxyMutableArray;

  // Case 2: ok, accounts has initialized with empty
  p.accounts = [@[] mutableCopy];
  proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
  XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue(proxyMutableArray.count == 0);

  // Case 3: add account by public API addAccount:
  [p addAccount:[Account new]];
  proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
  XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue(proxyMutableArray.count == 1);
  
  // Case 4: add account by proxy mutable collection
  proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
  [proxyMutableArray addObject:[Account new]];
  XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
  XCTAssertTrue(proxyMutableArray.count == 2);
    
  // Case 5: add more item for immutable array
  [p setValue:@[[Account new]] forKey:@"frozenAccounts"];
  proxyMutableArray = [p mutableArrayValueForKey:@"frozenAccounts"];
  [proxyMutableArray addObject:[Account new]];
  XCTAssertTrue(proxyMutableArray.count == 2);
  XCTAssertTrue(p.frozenAccounts.count == 2);
}
```



### （4）KVC对象校验属性

NSKeyValueCoding的API提供下面2个API，用于KVC对象校验属性是否有效[^5]

```objective-c
- (BOOL)validateValue:(inout id  _Nullable *)ioValue forKey:(NSString *)inKey error:(out NSError * _Nullable *)outError;
- (BOOL)validateValue:(inout id  _Nullable *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError * _Nullable *)outError;
```

说明

> validateValue:forKeyPath:error:方法，内部实现是依次调用valueForKey，而且每次调用valueForKey后，接着调用validateValue:forKey:error:方法



KVC类不直接实现上面的方法，实现每个属性的校验方法，方法签名如下

```objective-c
- (BOOL)validateXXX:(inout id  _Nullable __autoreleasing *)ioValue error:(out NSError *__autoreleasing  _Nullable *)outError
```

XXX是属性的getter名。

说明

> 如果不实现上面的方法，validateValue:forKey:error:方法和validateValue:forKeyPath:error:方法，都默认返回YES



举个例子，如下

```objective-c
@implementation Person
- (BOOL)validateName:(inout id  _Nullable __autoreleasing *)ioValue error:(out NSError *__autoreleasing  _Nullable *)outError {
    if (ioValue == NULL) {
        if (outError) {
            *outError = [NSError errorWithDomain:@"KVCDomaine" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Invalid parameter" }];
        }
        return NO;
    }
    
    NSString *name = *ioValue;
    
    if (name && ![name isKindOfClass:[NSString class]]) {
        if (outError) {
            *outError = [NSError errorWithDomain:@"KVCDomaine" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Invalid parameter" }];
        }
        return NO;
    }
    
    if (self.name == name) {
        return YES;
    }
    
    // Note: name is safe NSString object
    if ([self.name isKindOfClass:[NSString class]] &&
        [name isEqual:self.name]) {
        return YES;
    }
    
    if (outError) {
        *outError = [NSError errorWithDomain:@"KVCDomaine" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Value not match" }];
    }
    
    return NO;
}
@end
  
- (void)test_validateValue_forKey_error {
    BOOL output;
    NSError *error;
    NSString *name;
    
    Person *person = [[Person alloc] init];
    name = nil;
    
    // Case 1: ok, both nil
    output = [person validateValue:&name forKey:@"name" error:&error];
    XCTAssertTrue(output);
    
    // Case 2
    name = @"John";
    output = [person validateValue:&name forKey:@"name" error:&error];
    XCTAssertFalse(output);

    // Case 3: ok, both value is same the string
    person.name = @"John";
    output = [person validateValue:&name forKey:@"name" error:&error];
    XCTAssertTrue(output);
    
    // Case 4: false
    NSString *object = (NSString *)[NSObject new];
    person.name = object;    
    // false, object is expected as NSString
    output = [person validateValue:&object forKey:@"name" error:&error];
    XCTAssertFalse(output);
    
    // Case 5: ok, default return YES if not implement -[Person validateAge:error:]
    output = [person validateValue:&name forKey:@"age" error:&error];
    XCTAssertTrue(output);
}
```















## 2、使用KVC访问ivar变量

























1、accessInstanceVariablesDirectly

TODO:

 https://stackoverflow.com/questions/6122398/objective-c-why-private-ivars-are-not-hidden-from-the-outside-access-when-using

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/SearchImplementation.html#//apple_ref/doc/uid/20000955

http://jerrymarino.com/2014/01/31/objective-c-private-instance-variable-access.html

https://useyourloaf.com/blog/private-ivars/





## 3、keyPath的集合操作符（Collection Operators）[^1]

​       集合操作符是以`@`开头，后面跟着特定关键词的字符串，用于在KVC（KeyValueCoding）的`valueForKeyPath:`方法中。

​       完整的keyPath结构，分为三个部分：Left key path、Collection operator、Right key path，如下

![](images/keypath.jpg)



集合操作符（Collection Operator）根据行为，分为下面三种操作符

* Aggregation Operator（聚合操作符），将一系列对象做聚合操作，得到单个对象。例如`@count`
* Array Operator（数组操作符），返回NSArray对象。一般是原对象集合的子集。
* Nesting Operator（嵌套操作符），适用于集合嵌套集合的情况。



### Aggregation Operators



| 操作符的使用格式                                 | 含义     | 返回值类型           |
| ------------------------------------------------ | -------- | -------------------- |
| [collectionObject valueForKeyPath:@avg.property] | 取平均数 | NSNumber             |
| [collectionObject valueForKeyPath:@count]        | 取个数   | NSNumber             |
| [collectionObject valueForKeyPath:@max.property] | 取最大数 | id，根据property确定 |
| [collectionObject valueForKeyPath:@min.property] | 取最小数 | id，根据property确定 |
| [collectionObject valueForKeyPath:@sum.property] | 取总数   | NSNumber             |

如果是对集合中元素本身操作，而不是元素上的属性，则将property换成self，例如@sum.self。

举个例子，如下

```objective-c
NSArray *pattern = @[@5, @4, @3, @2];
output = [pattern valueForKeyPath:@"@sum.self"];
XCTAssertTrue([output isKindOfClass:[NSNumber class]]);
XCTAssertEqualObjects(output, @(14));
```





### Array Operators



| 操作符的使用格式                                         | 含义                             | 返回值类型             |
| -------------------------------------------------------- | -------------------------------- | ---------------------- |
| [array valueForKeyPath:@distinctUnionOfObjects.property] | 将一维数组的property求不重复并集 | NSArray\<PropertyType> |
| [array valueForKeyPath:@unionOfObjects.property]         | 将一维数组的property的并集       | NSArray\<PropertyType> |



### Nesting Operators



| 操作符的使用格式                                             | 含义                                              | 返回值类型             |
| :----------------------------------------------------------- | :------------------------------------------------ | ---------------------- |
| [arrayOfArrays valueForKeyPath:@distinctUnionOfArrays.property] | 将二维数组中所有元素的property求不重复并集        | NSArray\<PropertyType> |
| [arrayOfArrays valueForKeyPath:@unionOfArrays.property]      | 将二维数组中所有元素的property求并集              | NSArray\<PropertyType> |
| [setOfSets valueForKeyPath:@distinctUnionOfSets.property]    | 将二维集合(NSSet)中所有元素的property求不重复并集 | NSSet\<PropertyType>   |



示例：将嵌套的二维数组转成一维数组，如下

```objective-c
NSArray *flattedArray = [twoDimensionalArray valueForKeyPath:@"@unionOfArrays.self"];
```





## 3、KVC常见问题





## References

[^1]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html#//apple_ref/doc/uid/20002176-SW9 Apple KVC 文档
[^2]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/index.html#//apple_ref/doc/uid/10000107i

[^3]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/BasicPrinciples.html#//apple_ref/doc/uid/20002170-BAJEAIEE
[^4]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/AccessingCollectionProperties.html#//apple_ref/doc/uid/10000107i-CH4-SW1
[^5]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/ValidatingProperties.html#//apple_ref/doc/uid/10000107i-CH18-SW1

