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



### （5）KVC的Search Pattern[^6]

通过上面的介绍，NSKeyValueCoding的API中最核心的API，是下面2个方法

```objective-c
// Basic Getter
- (id)valueForKey:(NSString *)key;
// Basic Setter
- (void)setValue:(id)value forKey:(NSString *)key;
```

这里分别称为Basic Getter和Basic Setter。



#### a. Basic Getter的Search Pattern

给定key的情况下，valueForKey:方法的实现，按照下面搜索顺序去获取对应的值

1. 按照`get<Key>`、`<key>`、 `is<Key>`、`_<key>`的顺序，检查实例对象的accessor方法是否存在。如果存在，转到第5步，否则继续下一步骤。

   > 注意：(1) `_<key>`也是方法名，并不是实例变量名; (2) `is<Key>`必须是@property中声明的getter方法，而不是只实现形如`is<Key>`方法名，这样是不能被调用到的。

2. 检查实例对象是否具有NSArray行为。看是否都实现下面3个方法，缺一个都不行

   ```objective-c
   countOf<Key>
   objectIn<Key>AtIndex:
   <key>AtIndexes:
   ```

   如果都满足，则调用相应方法获取实例对象的每个“元素”，并对每个对象进行调用valueForKey:方法，组成NSArray结果返回出来。如果不满足，则继续下一步骤。

3. 检查实例对象是否具有NSSet行为。看是否都实现下面3个方法，缺一个都不行

   ```objective-c
   countOf<Key>
   enumeratorOf<Key>
   memberOf<Key>:
   ```

   如果都满足，处理过程和第2个步骤类似。如果不满足，则继续下一步骤。

4. 如果没有找到对应的accessor方法，检查实例对象的行为也不是集合（NSArray或NSSet），则检查类方法`accessInstanceVariablesDirectly` 。如果该类方法返回YES（默认是返回YES），说明可以访问实例变量，否则转到第6步。如果允许访问实例变量，则按照 `_<key>`、`_is<Key>`、 `<key>`、`is<Key>`的顺序，查找实例变量，如果找到转到第5步，否则转到第6步。

5. 到这一步，将获取到值，进行类型判断，如果是对象类型，则直接返回；如果是可以转成NSNumber，则转成NSNumber返回；如果是可以转成NSValue，则转成NSValue返回

6. 到这一步，说明没有找到对应的key，调用valueForUndefinedKey:方法。该方法默认会抛出NSUndefinedKeyException异常



官方描述，如下

> The default implementation of `valueForKey:`, given a `key` parameter as input, carries out the following procedure, operating from within the class instance receiving the `valueForKey:` call.
>
> 1. Search the instance for the first accessor method found with a name like `get<Key>`, `<key>`, `is<Key>`, or `_<key>`, in that order. If found, invoke it and proceed to step 5 with the result. Otherwise proceed to the next step.
>
> 2. If no simple accessor method is found, search the instance for methods whose names match the patterns `countOf<Key>` and `objectIn<Key>AtIndex:` (corresponding to the primitive methods defined by the `NSArray` class) and `<key>AtIndexes:` (corresponding to the `NSArray` method `objectsAtIndexes:`).
>
>    If the first of these and at least one of the other two is found, create a collection proxy object that responds to all `NSArray` methods and return that. Otherwise, proceed to step 3.
>
>    The proxy object subsequently converts any `NSArray` messages it receives to some combination of `countOf<Key>`, `objectIn<Key>AtIndex:`, and `<key>AtIndexes:` messages to the key-value coding compliant object that created it. If the original object also implements an optional method with a name like `get<Key>:range:`, the proxy object uses that as well, when appropriate. In effect, the proxy object working together with the key-value coding compliant object allows the underlying property to behave as if it were an `NSArray`, even if it is not.
>
> 3. If no simple accessor method or group of array access methods is found, look for a triple of methods named `countOf<Key>`, `enumeratorOf<Key>`, and `memberOf<Key>:` (corresponding to the primitive methods defined by the `NSSet` class).
>
>    If all three methods are found, create a collection proxy object that responds to all `NSSet` methods and return that. Otherwise, proceed to step 4.
>
>    This proxy object subsequently converts any `NSSet` message it receives into some combination of `countOf<Key>`, `enumeratorOf<Key>`, and `memberOf<Key>:` messages to the object that created it. In effect, the proxy object working together with the key-value coding compliant object allows the underlying property to behave as if it were an `NSSet`, even if it is not.
>
> 4. If no simple accessor method or group of collection access methods is found, and if the receiver's class method `accessInstanceVariablesDirectly` returns `YES`, search for an instance variable named `_<key>`, `_is<Key>`, `<key>`, or `is<Key>`, in that order. If found, directly obtain the value of the instance variable and proceed to step 5. Otherwise, proceed to step 6.
>
> 5. If the retrieved property value is an object pointer, simply return the result.
>
>    If the value is a scalar type supported by `NSNumber`, store it in an `NSNumber` instance and return that.
>
>    If the result is a scalar type not supported by NSNumber, convert to an `NSValue` object and return that.
>
> 6. If all else fails, invoke `valueForUndefinedKey:`. This raises an exception by default, but a subclass of `NSObject` may provide key-specific behavior.



举个例子，如下

```objective-c
@class Transaction;

@interface Account : NSObject
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, assign) double openingBalance;
@property (nonatomic, assign, getter=isCountOfItemChanged) NSInteger countOfItemChanged;
@property (nonatomic, strong) NSMutableArray<Transaction *> *transactions;
@end

@implementation Account {
    NSString *_privateIvarName1;
    NSString *_isPrivateIvarName2;
    NSString *privateIvarName3;
    NSString *isPrivateIvarName4;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _privateIvarName1 = @"private_ivar1";
        _isPrivateIvarName2 = @"private_ivar2";
        privateIvarName3 = @"private_ivar3";
        isPrivateIvarName4 = @"private_ivar4";
    }
    return self;
}
- (NSString *)getName {
    return @"Anonymous";
}
- (double)openingBalance {
    return 3.14;
}
// Note: for test to compare with isCountOfItemChanged
/*
- (NSInteger)countOfItemChanged {
    return 5;
}
 */
- (NSInteger)isCountOfItemChanged {
    return 5;
}
- (NSMutableArray *)_privateTransactions {
    return [@[] copy];
}
@end
  
- (void)test_valueForKey_search_pattern {
    Account *account = [[Account alloc] init];
    id output;
    
    // Step1: first loop to check accessor methods
    
    // Case 1: get<Key> accessor method
    output = [account valueForKey:@"name"];
    XCTAssertEqualObjects(output, @"Anonymous");
    
    // Case 2: <key> accessor method
    output = [account valueForKey:@"openingBalance"];
    XCTAssertEqualObjects(output, @(3.14));
    
    // Case 3: is<Key> accessor method
    output = [account valueForKey:@"countOfItemChanged"];
    XCTAssertEqualObjects(output, @(5));
    
    // Case 4: _key accessor method
    output = [account valueForKey:@"privateTransactions"];
    XCTAssertEqualObjects(output, @[]);
    
    // Step2: second loop to check the account if behavor as NSArray
    
    // Step3: third loop to check the account if behavor as NSSet
    
    // Step4: fourth loop to check the account's ivar
    
    // Case 1: _<key>
    output = [account valueForKey:@"privateIvarName1"];
    XCTAssertEqualObjects(output, @"private_ivar1");
    
    // Case 2: _is<Key>
    output = [account valueForKey:@"privateIvarName2"];
    XCTAssertEqualObjects(output, @"private_ivar2");
    
    // Case 3: <key>
    output = [account valueForKey:@"privateIvarName3"];
    XCTAssertEqualObjects(output, @"private_ivar3");
    
    // Case 4: is<Key>
    output = [account valueForKey:@"privateIvarName4"];
    XCTAssertEqualObjects(output, @"private_ivar4");
    
    // Step5: finally, call valueForUndefinedKey:, and throw exception by default
    XCTAssertThrowsSpecificNamed([account valueForKey:@"never_existed_key"], NSException, NSUndefinedKeyException);
}
```



通过上面的分析，可以看出

* 通过KVC可以获取对象的私有实例变量，而且通过类方法`accessInstanceVariablesDirectly`可以阻止这一行为。当然除了使用KVC方式，还有其他方式可以访问对象的私有实例变量[^7]
* 最好不要将方法命名以`_`开头，以免被KVC误调用。





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
[^6]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/SearchImplementation.html#//apple_ref/doc/uid/20000955-CJBBBFFA
[^7]:http://jerrymarino.com/2014/01/31/objective-c-private-instance-variable-access.html



